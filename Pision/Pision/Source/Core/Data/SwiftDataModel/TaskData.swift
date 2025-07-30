//
//  TaskData.swift
//  Pision
//
//  Created by 여성일 on 7/23/25.
//

import Foundation
import SwiftData

@Model
class TaskData {
  @Attribute(.unique) var id: UUID = UUID()
  var startTime: Date
  var endTime: Date
  var averageScore: Float
  var focusRatio: [Float]  // 각 30초 구간별 총합 점수들
  var focusTime: Int
  var durationTime: Int
  var snoozeImageDatas: [Data]
  var targetScore: Int?  // 목표 점수 (옵셔널)
  
  @Relationship(deleteRule: .cascade) var avgCoreDatas: [AvgCoreScore]  // 30초 단위 Core 점수들
  @Relationship(deleteRule: .cascade) var avgAuxDatas: [AvgAuxScore]    // 30초 단위 Aux 점수들
  
  // 기존 생성자 (기존 코드 호환성 유지)
  init(
    startTime: Date,
    endTime: Date,
    averageScore: Float,
    focusRatio: [Float],
    focusTime: Int,
    durationTime: Int,
    snoozeImageDatas: [Data],
    avgCoreDatas: [AvgCoreScore],
    avgAuxDatas: [AvgAuxScore]
  ) {
    self.startTime = startTime
    self.endTime = endTime
    self.averageScore = averageScore
    self.focusRatio = focusRatio
    self.focusTime = focusTime
    self.durationTime = durationTime
    self.snoozeImageDatas = snoozeImageDatas
    self.avgCoreDatas = avgCoreDatas
    self.avgAuxDatas = avgAuxDatas
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
    avgCoreDatas: [AvgCoreScore],
    avgAuxDatas: [AvgAuxScore],
    targetScore: Int?
  ) {
    self.startTime = startTime
    self.endTime = endTime
    self.averageScore = averageScore
    self.focusRatio = focusRatio
    self.focusTime = focusTime
    self.durationTime = durationTime
    self.snoozeImageDatas = snoozeImageDatas
    self.avgCoreDatas = avgCoreDatas
    self.avgAuxDatas = avgAuxDatas
    self.targetScore = targetScore
  }
}

// MARK: - 30초 구간별 점수 계산 메서드
extension TaskData {
  /// 30초 구간별 Aux 점수들의 평균을 계산합니다.
  func averageAuxScore() -> Double {
    guard !avgAuxDatas.isEmpty else {
      return 0.0
    }
    let total = avgAuxDatas.map { Double($0.avgAuxScore) }.reduce(0, +)
    return total / Double(avgAuxDatas.count)
  }

  /// 30초 구간별 Core 점수들의 평균을 계산합니다.
  func averageCoreScore() -> Double {
    guard !avgCoreDatas.isEmpty else {
      return 0.0
    }
    let total = avgCoreDatas.map { Double($0.avgCoreScore) }.reduce(0, +)
    return total / Double(avgCoreDatas.count)
  }
  
  /// 집중도가 임계값 이상인 구간의 개수를 반환합니다.
  func focusedSegmentCount(threshold: Float = 70.0) -> Int {
    return focusRatio.filter { $0 >= threshold }.count
  }
  
  /// 집중도 비율을 계산합니다 (0.0 ~ 1.0).
  func calculateFocusRatio(threshold: Float = 70.0) -> Float {
    guard !focusRatio.isEmpty else { return 0.0 }
    return Float(focusedSegmentCount(threshold: threshold)) / Float(focusRatio.count)
  }
  
  /// 가장 높은 점수를 가진 구간의 점수를 반환합니다.
  func bestSegmentScore() -> Float {
    return focusRatio.max() ?? 0.0
  }
  
  /// 가장 낮은 점수를 가진 구간의 점수를 반환합니다.
  func worstSegmentScore() -> Float {
    return focusRatio.min() ?? 0.0
  }
  
  /// 30초 구간의 총 개수를 반환합니다.
  var segmentCount: Int {
    return focusRatio.count
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
