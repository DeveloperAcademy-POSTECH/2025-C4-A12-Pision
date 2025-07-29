//
//  VisionManager.swift
//  PisionTest2
//
//  Created by 여성일 on 7/13/25.
//
//
//import Foundation
//import Vision
//

import Foundation
import Vision

// MARK: - VisionManager
final class VisionManager: ObservableObject {
  // Published Var
  @Published private(set) var ears: [Float] = []
  @Published private(set) var yaws: [Float] = []
  @Published private(set) var latestYaw: Float = 10.0
  @Published private(set) var shoulderPoints: (left: CGPoint, right: CGPoint)? = nil
  @Published private(set) var faceRectangle: [CGRect] = []
  @Published private(set) var mlPredictions: [String] = []
  @Published private(set) var blinkCount: Int = 0
  @Published private(set) var isFistHeld: Bool = false
  
  var onSnoozeDetected: ((Bool) -> Void)?
  var onFistDetected: (() -> Void)?
  
  // General var
  private let sequenceHandler = VNSequenceRequestHandler()
  private let faceRequest = VNDetectFaceLandmarksRequest()
  private let poseRequest = VNDetectHumanBodyPoseRequest()
  private let handRequest = VNDetectHumanHandPoseRequest()
  
  private var snoozeCounter = 0
  private let snoozeThresholdFrames = 30 // 약 2초 (15fps 기준)
  private var isSnoozeAlreadyDetected = false
  
  // Manager
  private let mlManager = MLManager()!
  private let scoreManager = ScoreManager()
  
  private var isBlink: Bool = false
  private var firstWorkItem: DispatchWorkItem?
}

// MARK: - General Func
extension VisionManager {
  /// 모든 데이터를 초기화 합니다.
  /// 새로운 세션이나, 측정을 시작하기 전에 이전 데이터를 초기화할 때 사용합니다.
  func reset() {
    ears.removeAll()
    yaws.removeAll()
    mlPredictions.removeAll()
    blinkCount = 0
  }
  
  /// 얼굴의 랜드마크 정보를 처리하여 고개 회전 각도(YAW), 눈 비율(EAR), 눈 깜빡임 여부를 계산합니다.
  /// Vision 프레임워크를 이용해 얼굴을 분석하고, 분석된 결과를 기반으로 내부 상태를 업데이트합니다.
  /// - Parameter pixelBuffer: 분석할 영상 프레임의 픽셀 버퍼입니다.
  func processMeasureFaceLandMark(pixelBuffer: CVPixelBuffer) {
    do {
      try sequenceHandler.perform([faceRequest], on: pixelBuffer)
      guard let results = faceRequest.results, !results.isEmpty else {
        DispatchQueue.main.async {
          self.latestYaw = 10.0
        }
        return
      }
      
      for face in results {
        if let yaw = face.yaw?.floatValue {
          let absYaw = abs(yaw)
          yaws.append(absYaw)
        }
        
        if let landmarks = face.landmarks,
           let leftEye = landmarks.leftEye,
           let rightEye = landmarks.rightEye {
          let leftEAR = calculateEAR(leftEye)
          let rightEAR = calculateEAR(rightEye)
          let avgEAR = (leftEAR + rightEAR) / 2.0
          ears.append(avgEAR)
          countBlink(leftEAR: CGFloat(leftEAR), rightEAR: CGFloat(rightEAR))
        }
      }
    } catch {
      print("Face Landmark 처리 실패")
    }
  }
  
  func processGuidingFaceLandMark(pixelBuffer: CVPixelBuffer) {
    do {
      try sequenceHandler.perform([faceRequest], on: pixelBuffer)
      guard let results = faceRequest.results, !results.isEmpty else {
        return
      }
      
      for face in results {
        if let yaw = face.yaw?.floatValue {
          let absYaw = abs(yaw)
          DispatchQueue.main.async {
            self.latestYaw = absYaw
          }
        }
      }
    } catch {
      print("Face Landmark 처리 실패")
    }
  }
  
  /// 사람의 몸 자세를 분석하여 머신러닝 모델로부터 예측 결과(레이블)를 받아옵니다.
  /// Vision 프레임워크를 사용해 포즈를 추출하고, 추출된 첫 번째 결과를 ML 모델에 입력하여 동작을 분류합니다.
  /// - Parameter pixelBuffer: 분석할 영상 프레임의 픽셀 버퍼입니다.
//  func processMeasureBodyPose(pixelBuffer: CVPixelBuffer) {
//    do {
//      try sequenceHandler.perform([poseRequest], on: pixelBuffer)
//      guard let first = poseRequest.results?.first else { return }
//      
//      let label = mlManager.bodyPosePredict(from: first)
//      DispatchQueue.main.async {
//        self.mlPredictions.append(label)
//        
//        let lastEAR = self.ears.last ?? 1.0
//        let isSnooze = (label == "Snooze" && lastEAR < 0.1)
//        print(lastEAR, "lastEAR")
//        self.onSnoozeDetected?(isSnooze)
//      }
//    } catch {
//      print("Body Pose 처리 실패")
//    }
//  }
  
  func processMeasureBodyPose(pixelBuffer: CVPixelBuffer) {
    do {
      try sequenceHandler.perform([poseRequest], on: pixelBuffer)
      guard let first = poseRequest.results?.first else { return }

      let label = mlManager.bodyPosePredict(from: first)
      
      DispatchQueue.main.async {
        self.mlPredictions.append(label)
        
        let lastEAR = self.ears.last ?? 1.0
        let isSnoozePose = (label == "Snooze")
        let isEyesClosed = lastEAR < 0.1
        
        // snooze 조건 충족 중일 때 누적
        if isSnoozePose && isEyesClosed {
          self.snoozeCounter += 1
          
          if self.snoozeCounter >= self.snoozeThresholdFrames && !self.isSnoozeAlreadyDetected {
            self.isSnoozeAlreadyDetected = true
            self.onSnoozeDetected?(true)
          }
        } else {
          // 조건 충족 안 하면 초기화
          self.snoozeCounter = 0
          self.isSnoozeAlreadyDetected = false
          self.onSnoozeDetected?(false)
        }
      }
    } catch {
      print("Body Pose 처리 실패")
    }
  }
  
  func processGuidingBodyPose(pixelBuffer: CVPixelBuffer) {
    do {
      try sequenceHandler.perform([poseRequest], on: pixelBuffer)
      guard let first = poseRequest.results?.first else { return }
      
      // 어깨 위치 체크 (기존)
      guard let left = try? first.recognizedPoint(.leftShoulder),
            let right = try? first.recognizedPoint(.rightShoulder),
            left.confidence > 0.2, right.confidence > 0.2 else {
        DispatchQueue.main.async {
          self.shoulderPoints = nil
        }
        return
      }
      
      let points = (left: CGPoint(x: left.x, y: left.y),
                    right: CGPoint(x: right.x, y: right.y))
      
      DispatchQueue.main.async {
        self.shoulderPoints = points
      }
    } catch {
      print("Body Pose 처리 실패")
    }
  }
  
  func processHandPose(pixelBuffer: CVPixelBuffer) {
    do {
      try sequenceHandler.perform([handRequest], on: pixelBuffer)
      guard let first = handRequest.results?.first else { return }
      
      let label = mlManager.handPosePredict2(from: first).label
      let confidence = mlManager.handPosePredict2(from: first).confidence
      DispatchQueue.main.async {
        self.startFistTimer(label: label, confidence: confidence)
      }
    } catch {
      print("Hand Pose 처리 실패")
    }
  }
}

// MARK: - Private Func
extension VisionManager {
  /// 눈의 EAR(Eye Aspect Ratio)을 계산하여 눈이 얼마나 감겨 있는지를 측정합니다.
  /// EAR 값이 작을수록 눈이 감긴 상태에 가깝습니다.
  /// - Parameter eye: Vision에서 추출된 눈의 랜드마크 포인트입니다.
  /// - Returns: 계산된 EAR 값입니다. 포인트가 부족할 경우 기본값 0.25를 반환합니다.
  private func calculateEAR(_ eye: VNFaceLandmarkRegion2D) -> Float {
    let pts = eye.normalizedPoints
    guard pts.count >= 6 else { return 0.25 }
    let v1 = pts[1].eyeDistance(to: pts[5])
    let v2 = pts[2].eyeDistance(to: pts[4])
    let h = pts[0].eyeDistance(to: pts[3])
    return Float((v1 + v2) / (2 * h))
  }
  
  /// 양쪽 눈의 EAR 값을 기반으로 눈 깜빡임 여부를 판단하고 깜빡임 횟수를 증가시킵니다.
  /// EAR 값이 일정 임계값(threshold)보다 작을 경우 눈을 감은 것으로 판단합니다.
  /// - Parameters:
  ///   - leftEAR: 왼쪽 눈의 EAR 값
  ///   - rightEAR: 오른쪽 눈의 EAR 값
  ///   - threshold: 눈 감김을 판단할 기준 EAR 임계값 (기본값: 0.1)
  private func countBlink(leftEAR: CGFloat, rightEAR: CGFloat, threshold: CGFloat = 0.1) {
    let leftClosed = leftEAR < threshold
    let rightClosed = rightEAR < threshold
    if leftClosed && rightClosed {
      if !isBlink { isBlink = true }
    } else {
      if isBlink {
        blinkCount += 1
        isBlink = false
      }
    }
  }
  
  private func startFistTimer(label: String, confidence: Double) {
    if label == "Fist" && confidence > 0.99 {
      if self.firstWorkItem == nil {
        let work = DispatchWorkItem { [weak self] in
          self?.onFistDetected?()
        }
        self.firstWorkItem = work
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: work)
      }
    } else {
      self.resetFistTimer()
    }
  }
  
  private func resetFistTimer() {
    firstWorkItem?.cancel()
    firstWorkItem = nil
    isFistHeld = false
  }
}
