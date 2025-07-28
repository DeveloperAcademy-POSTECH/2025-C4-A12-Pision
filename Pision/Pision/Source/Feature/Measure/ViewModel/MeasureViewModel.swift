//
//  MainViewModel.swift
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
  @Published private(set) var isGuidingComplete: Bool = false
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
  private var coreScoreHistory: [CoreScoreModel] = []
  private var auxScoreHistory: [AuxScoreModel] = []
  private var coreScoreHistory10Minute: [AvgCoreScoreModel] = []
  private var auxScoreHistory10Minute: [AvgAuxScoreModel] = []
  private var taskData: TaskDataModel?
  private var focusTime: Int = 0
  private var focusRatios: [Float] = []
  private var snoozeImageDatas: [Data] = []

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
        print("호출")
        self.isShouldDimScreen = true
      }
    }
  }
  
  func timerStart() {
    timerManager.timerStart()
    timerState = .running
    timerManager.startAutoDim()
    cameraManager.startMeasuring()
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
  
  func timerStop(context: ModelContext, completion: @escaping (SaveResult) -> Void) {
    timerManager.timerStop()
    timerState = .stopped
    timerManager.cancelAutoDim()
    cameraManager.stopMeasuring()
  }
   
  func resetAutoDim() {
    timerManager.resetAutoDim()
    isShouldDimScreen = false
  }
}

// MARK: - Guiding
extension MeasureViewModel {
  func guidingStart(screenWidth: CGFloat) {
    cameraManager.startGuiding()
    checkYaw(screenWidth: screenWidth)
    
    Publishers.CombineLatest($isGuidingAngle, $isGuidingPose)
      .map { $0 && $1 }
      .removeDuplicates()
      .receive(on: DispatchQueue.main)
      .assign(to: &$isGuidingComplete)
  }
  
  func guidingFinish() {
    cameraManager.stopGuiding()
    isPresentedStartModal = false
    showCountdown = true
    //isNext = true
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

// MARK: - Measure
extension MeasureViewModel {
  private func calculateScores() {
    let core = scoreManager.calculateCore(
      from: visionManager.ears,
      yaws: visionManager.yaws,
      blinkCount: visionManager.blinkCount
    )
    let aux = scoreManager.calculateAux(
      from: visionManager.ears,
      yaws: visionManager.yaws,
      ml: visionManager.mlPredictions,
      blinkCount: visionManager.blinkCount
    )
    coreScoreHistory.append(core)
    auxScoreHistory.append(aux)
    
    let total = scoreManager.calculateTotal(core: core, aux: aux)
    
    currentFocusRatio = total
    if total >= 60 { focusTime += 30 }
    
    visionManager.reset()
  }
  
  private func save10MinuteAverage() {
    let last20Core = coreScoreHistory.suffix(20)
    let last20Aux = auxScoreHistory.suffix(20)
    guard last20Core.count == 20,
          last20Aux.count == 20 else { return }
    
    let avgCore = scoreManager.averageCore(from: Array(last20Core))
    coreScoreHistory10Minute.append(avgCore)
    
    let avgAux = scoreManager.averageAux(from: Array(last20Aux))
    auxScoreHistory10Minute.append(avgAux)
    
    let focusCount = zip(last20Core, last20Aux)
      .filter { scoreManager.calculateTotal(core: $0.0, aux: $0.1) >= 75 }
      .count
    
    let focusRatio = Float(focusCount * 30) / 600 * 100
    focusRatios.append(focusRatio)
  }
  
  private func saveRemainingAverage() {
    let remainderCount = min(coreScoreHistory.count % 20, auxScoreHistory.count % 20)
    guard remainderCount > 0 else { return }
    
    let remainderCore = coreScoreHistory.suffix(remainderCount)
    let remainderAux = auxScoreHistory.suffix(remainderCount)
    
    let avgCore = scoreManager.averageCore(from: Array(remainderCore))
    let avgAux = scoreManager.averageAux(from: Array(remainderAux))
    
    coreScoreHistory10Minute.append(avgCore)
    auxScoreHistory10Minute.append(avgAux)
    
    let focusCount = zip(remainderCore, remainderAux)
      .filter { scoreManager.calculateTotal(core: $0.0, aux: $0.1) >= 60 }
      .count
    let ratio = Float(focusCount * 30) / Float(remainderCount * 30) * 100
    focusRatios.append(ratio)
  }
  
  private func saveTaskDataAndSaveToSwiftData(context: ModelContext, completion: @escaping (SaveResult) -> Void) {
    if secondsElapsed < 600 {
      completion(.skippedLessThan10Minutes)
      return
    }
    
    let avgScore = (Float(focusTime) / Float(secondsElapsed)) * 100
    let data = TaskDataModel(
      startTime: Date().addingTimeInterval(-TimeInterval(secondsElapsed)),
      endTime: Date(),
      averageScore: avgScore,
      focusRatio: focusRatios,
      focusTime: focusTime,
      durationTime: secondsElapsed,
      snoozeImageDatas: snoozeImageDatas,
      avgCoreDatas: coreScoreHistory10Minute,
      avgAuxDatas: auxScoreHistory10Minute
    )
    self.taskData = data
    
    guard let taskData = self.taskData else {
      completion(.failed)
      return
    }
    
    swiftDataManager.saveTaskDataToSwiftData(context: context, taskData: taskData) { isSuccess in
      if isSuccess {
        completion(.success)
      } else {
        completion(.failed)
      }
    }
  }
}
