//
//  MeasureViewModel.swift
//  PisionTest2
//
//  Created by 여성일 on 7/13/25.
//

import AVFoundation
import Combine
import SwiftData
import SwiftUI
import Foundation

final class MeasureViewModel: ObservableObject {
  // MARK: - Timer Var
  @Published private(set) var timerState: TimerState = .stopped
  @Published private(set) var secondsElapsed: Int = 0
  @Published var isShouldDimScreen: Bool = false
  @Published var isAutoBrightnessModeOn: Bool = false {
    didSet {
      if !isAutoBrightnessModeOn {
        timerManager.startAutoDim()
      } else {
        timerManager.cancelAutoDim()
        isShouldDimScreen = false
      }
    }
  }
  
  var timeString: String {
    let hrs = secondsElapsed / 3600
    let mins = (secondsElapsed % 3600) / 60
    let secs = secondsElapsed % 60
    return String(format: "%02d:%02d:%02d", hrs, mins, secs)
  }

  // MARK: - Guiding Var
  @Published private(set) var isNext: Bool = false
  @Published private(set) var isGuidingAngle: Bool = false
  @Published private(set) var isGuidingPose: Bool = false
  @Published private(set) var isPresentedStartModal: Bool = false
  @Published private(set) var showCountdown = false
  private var guidingTimer: Timer?
  private var guidingStartTime: Date?
  
  var guideCaptionString: String {
    switch (isGuidingAngle, isGuidingPose) {
    case (true, false):
      return "어깨를 중앙에\n위치 시켜주세요"
    case (false, true):
      return "얼굴을 중앙에\n위치 시켜주세요"
    case (true, true):
      return "해당 자세를 3초 이상\n유지해주세요"
    default:
      return "카메라를 편하신 곳에\n거치 시켜주세요 "
    }
  }
  
  // MARK: - Measure Var
  @Published private(set) var currentFocusRatio: Float = 0.0
  @Published var finishModal: MeasureFinishModalItems? = nil
  
  // 30초 단위로 수집되는 점수들
  @Published private(set) var coreScoreSegments: [CoreScoreModel] = []
  @Published private(set) var auxScoreSegments: [AuxScoreModel] = []
  
  @Published private(set) var taskData: TaskDataModel?
  private var measurementStartTime: Date?
  private var snoozeImageDatas: [Data] = []
  
  // MARK: - 목표 점수 관리
  private let targetScoreManager = TargetScoreManager.shared
  
  /// 현재 목표 점수를 반환합니다
  var currentTargetScore: Int {
    return targetScoreManager.getCurrentTargetScore()
  }
  
  // MARK: - General
  // Manager
  private let cameraManager: CameraManager
  private let visionManager = VisionManager()
  private let scoreManager = ScoreManager()
  private let swiftDataManager = SwiftDataManager()
  private let timerManager = TimerManager()
  
  // Session
  var session: AVCaptureSession {
    cameraManager.session
  }
  
  // init
  init() {
    cameraManager = CameraManager(visionManager: visionManager)
    cameraManager.requestAndCheckPermissions()
    
    bindTimer()
    bindGuiding()
    bindVisionManager()
    
    visionManager.onSnoozeDetected = { [weak self] detected in
      guard detected else { return }
      self?.cameraManager.captureSnoozePhoto()
    }
    
    cameraManager.onPhotoCaptured = { [weak self] data in
      self?.snoozeImageDatas.append(data)
    }
  }
  
  func debugPrintAllSavedData(context: ModelContext) {
    swiftDataManager.fetchAllTaskData(context: context)
  }
}

// MARK: - Camera Func
extension MeasureViewModel {
  func cameraStart() {
    cameraManager.startSession()
  }
  
  func cameraStop() {
    cameraManager.stopSession()
  }
}

// MARK: - Timer
extension MeasureViewModel {
  private func bindTimer() {
    timerManager.onTick = { [weak self] sec in
      guard let self = self else { return }
      DispatchQueue.main.async {
        self.secondsElapsed = sec
      }
    }
    
    timerManager.onAutoDim = { [weak self] in
      guard let self = self else { return }
      DispatchQueue.main.async {
        self.isShouldDimScreen = true
      }
    }
  }
  
  func timerStart() {
    measurementStartTime = Date()
    
    // 모든 데이터 초기화
    visionManager.reset()
    coreScoreSegments.removeAll()
    auxScoreSegments.removeAll()
    snoozeImageDatas.removeAll()
    currentFocusRatio = 0.0
    
    timerManager.timerStart()
    timerState = .running
    timerManager.startAutoDim()
    cameraManager.startMeasuring() // VisionManager의 30초 타이머도 자동 시작
  }
  
  func timerPause() {
    guard timerState == .running else { return }
    timerManager.timerPause()
    timerState = .pause
    cameraManager.stopMeasuring()
  }
  
  func timerResume() {
    guard timerState == .pause else { return }
    timerManager.timerResume()
    timerState = .running
    cameraManager.startMeasuring()
  }
  
  func timerStop() {
    timerManager.timerStop()
    timerState = .stopped
    timerManager.cancelAutoDim()
    cameraManager.stopMeasuring() // VisionManager의 finalizeMeasurement도 호출
  }
  
  func saveData(context: ModelContext) {
    saveTaskDataAndSaveToSwiftData(context: context)
  }
  
  func showModal() {
    timerPause()
    finishModal = secondsElapsed < 60 ? .shortTime : .longEnough // 1분으로 변경
  }
  
  func resetAutoDim() {
    timerManager.resetAutoDim()
    isShouldDimScreen = false
  }
}

// MARK: - Vision Manager Binding
extension MeasureViewModel {
  private func bindVisionManager() {
    // 30초 구간 완료 콜백
    visionManager.onSegmentCompleted = { [weak self] coreScore, auxScore in
      DispatchQueue.main.async {
        self?.coreScoreSegments.append(coreScore)
        self?.auxScoreSegments.append(auxScore)
        
        // 현재 구간의 총 점수 계산
        let totalScore = coreScore.coreScore * 0.7 + auxScore.auxScore * 0.3
        self?.currentFocusRatio = totalScore
        
        print("✅ 30초 구간 완료 - Core: \(String(format: "%.1f", coreScore.coreScore)), Aux: \(String(format: "%.1f", auxScore.auxScore)), Total: \(String(format: "%.1f", totalScore))")
      }
    }
  }
}

// MARK: - Guiding
extension MeasureViewModel {
  private func bindGuiding() {
    visionManager.onFistDetected = { [weak self] in
      guard let self = self else { return }
      
      if isPresentedStartModal {
        self.guidingFinish()
      }
    }
  }
  
  func guidingStart(screenWidth: CGFloat) {
    cameraManager.startGuiding()
    checkYaw(screenWidth: screenWidth)
  }
  
  func guidingFinish() {
    cameraManager.stopGuiding()
    isPresentedStartModal = false
    showCountdown = true
  }
  
  func checkGuidingStatus() {
    if isGuidingAngle && isGuidingPose {
      if guidingTimer == nil {
        guidingStartTime = Date()
        guidingTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
          guard let self = self, let start = self.guidingStartTime else { return }
          let elapsed = Date().timeIntervalSince(start)
          if elapsed >= 3.0 {
            self.guidingTimer?.invalidate()
            self.guidingTimer = nil
            self.isPresentedStartModal = true
          }
        }
      }
    } else {
      guidingTimer?.invalidate()
      guidingTimer = nil
      guidingStartTime = nil
    }
  }
  
  func countDownFinish() {
    showCountdown = false
    isNext = true
  }
  
  private func checkYaw(screenWidth: CGFloat) {
    visionManager.$latestYaw
      .receive(on: DispatchQueue.main)
      .map { $0 <= 0.7853982 }
      .assign(to: &$isGuidingAngle)
    
    visionManager.$shoulderPoints
      .receive(on: DispatchQueue.main)
      .map { points -> Bool in
        guard let points else { return false }
        let leftX = points.left.x * screenWidth
        let rightX = points.right.x * screenWidth
        return leftX >= 0 && rightX <= screenWidth
      }
      .assign(to: &$isGuidingPose)
  }
}

// MARK: - Measure & Save
extension MeasureViewModel {
  /// 전체 측정 데이터를 기반으로 최종 평균 점수를 계산합니다.
  private func calculateOverallAverageScore() -> Float {
    guard !coreScoreSegments.isEmpty,
          coreScoreSegments.count == auxScoreSegments.count else { return 0.0 }
    
    let totalScores = zip(coreScoreSegments, auxScoreSegments).map { core, aux in
      core.coreScore * 0.7 + aux.auxScore * 0.3
    }
    
    return totalScores.reduce(0, +) / Float(totalScores.count)
  }
  
  /// 집중 시간을 계산합니다 (점수 60점 이상인 구간).
  private func calculateFocusTime(threshold: Float = 60.0) -> Int {
    guard !coreScoreSegments.isEmpty,
          coreScoreSegments.count == auxScoreSegments.count else { return 0 }
    
    let focusedSegments = zip(coreScoreSegments, auxScoreSegments).compactMap { core, aux -> Bool in
      let totalScore = core.coreScore * 0.7 + aux.auxScore * 0.3
      return totalScore >= threshold
    }.filter { $0 }.count
    
    return focusedSegments * 30 // 각 구간이 30초
  }
  
  /// TaskData를 생성하고 SwiftData에 저장합니다.
  private func saveTaskDataAndSaveToSwiftData(context: ModelContext) {
    guard let startTime = measurementStartTime else {
      print("❌ 측정 시작 시간을 찾을 수 없습니다.")
      return
    }
    
    let endTime = Date()
    let averageScore = calculateOverallAverageScore()
    let focusTime = calculateFocusTime()
    
    // 전역 목표 점수 가져오기
    let targetScore = targetScoreManager.getCurrentTargetScore()
    
    let taskData = TaskDataModel(
      startTime: startTime,
      endTime: endTime,
      averageScore: averageScore,
      focusRatio: [], // TaskDataModel에서 계산됨
      focusTime: focusTime,
      durationTime: secondsElapsed,
      snoozeImageDatas: snoozeImageDatas,
      coreScoreSegments: coreScoreSegments,
      auxScoreSegments: auxScoreSegments,
      targetScore: targetScore > 0 ? targetScore : nil // 목표 점수 포함
    )
    
    self.taskData = taskData
    
    // SwiftData에 저장
    swiftDataManager.saveTaskDataToSwiftData(context: context, taskData: taskData)
    
    print("📊 측정 완료 요약:")
    print("   - 총 측정 시간: \(secondsElapsed)초")
    print("   - 30초 구간 수: \(coreScoreSegments.count)개")
    print("   - 평균 점수: \(String(format: "%.1f", averageScore))점")
    print("   - 집중 시간: \(focusTime)초")
    print("   - 집중 비율: \(String(format: "%.1f", taskData.calculateFocusRatio() * 100))%")
    if let target = taskData.targetScore {
      let similarity = taskData.calculateSimilarityScore() ?? 0
      print("   - 목표 점수: \(target)%")
      print("   - 목표 달성도: \(similarity)점")
    }
    
    // 측정 완료 후 목표 점수 초기화
    targetScoreManager.resetTargetScore()
  }
}
