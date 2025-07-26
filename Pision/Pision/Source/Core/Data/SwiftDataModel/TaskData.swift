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
  var focusRatio: [Float]
  var focusTime: Int
  var durationTime: Int
  var snoozeImageDatas: [Data]
  
  @Relationship(deleteRule: .cascade) var avgCoreDatas: [AvgCoreScore]
  @Relationship(deleteRule: .cascade) var avgAuxDatas: [AvgAuxScore]
  
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
  }
}

// MARK: - avgCoreDatas, avgAuxDatas들의 평균을 내는 함수
extension TaskData {
  func averageAuxScore() -> Double {
    guard !avgAuxDatas.isEmpty else {
      return 0.0
    }
    let total = avgAuxDatas.map { Double($0.avgAuxScore) }.reduce(0, +)
    return total / Double(avgAuxDatas.count)
  }

  func averageCoreScore() -> Double {
    guard !avgCoreDatas.isEmpty else {
      return 0.0
    }
    let total = avgCoreDatas.map { Double($0.avgCoreScore) }.reduce(0, +)
    return total / Double(avgCoreDatas.count)
  }
}
