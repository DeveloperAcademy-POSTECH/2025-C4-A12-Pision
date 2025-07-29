//
//  MLManager.swift
//  PisionTest2
//
//  Created by 여성일 on 7/13/25.
//

import CoreML
import Vision

// MARK: - MLManager
final class MLManager {
  private let snoozeModel: pisionModel
  private let handPoseModel: MyHandPose
  private var poseBuffer: [VNHumanBodyPoseObservation] = []
  private var handPoseBuffer: [VNHumanHandPoseObservation] = []
  
  init?() {
    guard let snoozeModel = try? pisionModel(configuration: MLModelConfiguration()) else {
      print("Log: 모델 로드 실패")
      return nil
    }
    
    guard let handPoseModel = try? MyHandPose(configuration: MLModelConfiguration()) else {
      print("Log: 핸드 포즈 모델 로드 실패")
      return nil
    }
    
    self.snoozeModel = snoozeModel
    self.handPoseModel = handPoseModel
  }
}

// MARK: - General Func
extension MLManager {
  /// 사람의 자세 관측값을 입력으로 받아, 학습된 CoreML 모델을 통해 동작 라벨을 예측합니다.
  ///
  /// - Parameter observation: `VNHumanBodyPoseObservation` 형태의 단일 자세 프레임입니다.
  /// - Returns: 예측된 동작 라벨 문자열. 입력이 30프레임 미만일 경우 빈 문자열을 반환합니다.
  func bodyPosePredict(from observation: VNHumanBodyPoseObservation) -> String {
    poseBuffer.append(observation)
    
    if poseBuffer.count > 30 {
      poseBuffer.removeFirst()
    }
    
    guard poseBuffer.count == 30 else { return "" }
    
    do {
      let array = try MLMultiArray(shape: [30, 3, 18] as [NSNumber], dataType: .float32)
      
      let jointNames: [VNHumanBodyPoseObservation.JointName] = [
        .nose, .leftEye, .rightEye, .leftEar, .rightEar,
        .leftShoulder, .rightShoulder, .leftElbow, .rightElbow,
        .leftWrist, .rightWrist, .leftHip, .rightHip,
        .leftKnee, .rightKnee, .leftAnkle, .rightAnkle,
        .root
      ]
      
      for (frameIndex, observation) in poseBuffer.enumerated() {
        
        let points = try observation.recognizedPoints(.all)
        
        for (jointIndex, joint) in jointNames.enumerated() {
          if let point = points[joint] {
            array[[frameIndex as NSNumber, 0, jointIndex as NSNumber]] = NSNumber(value: Float(point.location.x))
            array[[frameIndex as NSNumber, 1, jointIndex as NSNumber]] = NSNumber(value: Float(point.location.y))
            array[[frameIndex as NSNumber, 2, jointIndex as NSNumber]] = NSNumber(value: Float(point.confidence))
          } else {
            array[[frameIndex as NSNumber, 0, jointIndex as NSNumber]] = 0
            array[[frameIndex as NSNumber, 1, jointIndex as NSNumber]] = 0
            array[[frameIndex as NSNumber, 2, jointIndex as NSNumber]] = 0
          }
        }
      }
      let result = try snoozeModel.prediction(poses: array)
      let label = result.label
      return label
    } catch {
      print("Log: 예측 에러")
    }
    return ""
  }
  
  func handPosePredict2(from observation: VNHumanHandPoseObservation) -> (label: String, confidence: Double) {
    do {
      let array = try MLMultiArray(
        shape: [1, 3, 21] as [NSNumber],
        dataType: .float32
      )
      
      let jointNames: [VNHumanHandPoseObservation.JointName] = [
        .indexDIP, .indexMCP, .indexPIP, .indexTip,
        .littleDIP, .littleMCP, .littlePIP, .littleTip,
        .middleDIP, .middleMCP, .middlePIP, .middleTip,
        .ringDIP, .ringMCP, .ringPIP, .ringTip,
        .thumbIP, .thumbMP, .thumbCMC, .thumbTip,
        .wrist
      ]
      
      // 한 프레임 관찰치에서 모든 관절 좌표 추출
      let points = try observation.recognizedPoints(.all)
      let b = NSNumber(value: 0) // batch index
      
      for (jIdx, joint) in jointNames.enumerated() {
        let j = NSNumber(value: jIdx)
        if let pt = points[joint] {
          array[[b, 0, j]] = NSNumber(value: Float(pt.location.x))
          array[[b, 1, j]] = NSNumber(value: Float(pt.location.y))
          array[[b, 2, j]] = NSNumber(value: Float(pt.confidence))
        } else {
          array[[b, 0, j]] = 0
          array[[b, 1, j]] = 0
          array[[b, 2, j]] = 0
        }
      }
      
      let result = try handPoseModel.prediction(poses: array)
      let label = result.label
      let confidence = result.labelProbabilities[label] ?? 0.0
      
      print(label, "label")
      print(confidence, "confidnece")
      if label == "Fist" {
        return (label, confidence)
      } else {
        return ("Extra", 0.0)
      }
    } catch {
      print("손 포즈 예측 에러:", error)
      return ("Extra", 0.0)
    }
  }
}
