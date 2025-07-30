//
//  TaskDataModel.swift
//  Pision
//
//  Created by 여성일 on 7/23/25.
//

import Foundation

struct TaskDataModel {
  let startTime: Date
  let endTime: Date
  let averageScore: Float
  let focusRatio: [Float]
  let focusTime: Int
  let durationTime: Int
  let snoozeImageDatas: [Data]
  let coreScoreSegments: [CoreScoreModel]    // 30초 단위 Core 점수들
  let auxScoreSegments: [AuxScoreModel]      // 30초 단위 Aux 점수들
  let targetScore: Int?                      // 목표 점수 (옵셔널)
  
  // 기존 생성자 (기존 코드 호환성 유지)
  init(
    startTime: Date,
    endTime: Date,
    averageScore: Float,
    focusRatio: [Float],
    focusTime: Int,
    durationTime: Int,
    snoozeImageDatas: [Data],
    coreScoreSegments: [CoreScoreModel],
    auxScoreSegments: [AuxScoreModel]
  ) {
    self.startTime = startTime
    self.endTime = endTime
    self.averageScore = averageScore
    self.focusRatio = focusRatio
    self.focusTime = focusTime
    self.durationTime = durationTime
    self.snoozeImageDatas = snoozeImageDatas
    self.coreScoreSegments = coreScoreSegments
    self.auxScoreSegments = auxScoreSegments
    self.targetScore = nil  // 기본값 nil
  }
  
  // 목표 점수를 포함한 새로운 생성자
  init(
    startTime: Date,
    endTime: Date,
    averageScore: Float,
    focusRatio: [Float],
    focusTime: Int,
    durationTime: Int,
    snoozeImageDatas: [Data],
    coreScoreSegments: [CoreScoreModel],
    auxScoreSegments: [AuxScoreModel],
    targetScore: Int?
  ) {
    self.startTime = startTime
    self.endTime = endTime
    self.averageScore = averageScore
    self.focusRatio = focusRatio
    self.focusTime = focusTime
    self.durationTime = durationTime
    self.snoozeImageDatas = snoozeImageDatas
    self.coreScoreSegments = coreScoreSegments
    self.auxScoreSegments = auxScoreSegments
    self.targetScore = targetScore
  }
}

// MARK: - TaskDataModel 확장 메서드
extension TaskDataModel {
  /// 30초 단위 Core 점수들의 평균을 계산합니다.
  func averageCoreScore() -> Float {
    guard !coreScoreSegments.isEmpty else { return 0.0 }
    let total = coreScoreSegments.map { $0.coreScore }.reduce(0, +)
    return total / Float(coreScoreSegments.count)
  }
  
  /// 30초 단위 Aux 점수들의 평균을 계산합니다.
  func averageAuxScore() -> Float {
    guard !auxScoreSegments.isEmpty else { return 0.0 }
    let total = auxScoreSegments.map { $0.auxScore }.reduce(0, +)
    return total / Float(auxScoreSegments.count)
  }
  
  /// 각 30초 구간별 총합 점수를 계산합니다.
  func totalScorePerSegment() -> [Float] {
    guard coreScoreSegments.count == auxScoreSegments.count else { return [] }
    
    return zip(coreScoreSegments, auxScoreSegments).map { core, aux in
      core.coreScore * 0.7 + aux.auxScore * 0.3
    }
  }
  
  /// 집중도가 임계값 이상인 구간의 비율을 계산합니다.
  func calculateFocusRatio(threshold: Float = 70.0) -> Float {
    let totalScores = totalScorePerSegment()
    guard !totalScores.isEmpty else { return 0.0 }
    
    let focusedSegments = totalScores.filter { $0 >= threshold }.count
    return Float(focusedSegments) / Float(totalScores.count)
  }
  
  /// 집중 시간을 계산합니다 (초 단위).
  func calculateFocusTime(threshold: Float = 70.0) -> Int {
    let totalScores = totalScorePerSegment()
    let focusedSegments = totalScores.filter { $0 >= threshold }.count
    return focusedSegments * 30 // 각 구간이 30초
  }
  
  /// 목표 달성도를 계산합니다 (targetScore가 있을 때만).
  func calculateSimilarityScore() -> Int? {
    guard let target = targetScore else { return nil }
    
    let difference = abs(averageScore - Float(target))
    
    switch difference {
    case 0...5: return 100
    case 5.1...10: return 90
    case 10.1...15: return 80
    case 15.1...20: return 70
    case 20.1...25: return 60
    case 25.1...30: return 50
    case 30.1...40: return 40
    case 40.1...50: return 30
    default: return 20
    }
  }
}
