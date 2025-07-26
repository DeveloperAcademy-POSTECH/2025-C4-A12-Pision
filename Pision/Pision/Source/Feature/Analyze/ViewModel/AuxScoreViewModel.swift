//
//  AuxScoreViewModel.swift
//  Pision
//
//  Created by rundo on 7/25/25.
//

import Foundation
import SwiftData
import SwiftUI

struct AuxScoreEntry: Identifiable {
  let id = UUID()
  let index: Int
  let value: Double
  let category: String
}

@MainActor
class AuxScoreViewModel: ObservableObject {
  @Published var isExpanded: Bool = false
  @Published private(set) var entries: [AuxScoreEntry] = []

  let taskData: TaskData

  init(taskData: TaskData) {
    self.taskData = taskData
  }

  var averageScoreText: String {
    String(format: "%.1f", taskData.averageAuxScore())
  }

  /// 데이터 포인트 개수
  var dataPointCount: Int {
    return taskData.avgAuxDatas.count
  }

  /// 정규화된 Blink Score (깜빡임 점수) - 파란색
  var normalizedBlinkScores: [Double] {
    return taskData.avgAuxDatas.map { Double($0.avgBlinkScore) * (100.0 / 25.0) }
  }

  /// 정규화된 Yaw Stability Score (고개 안정성) - 검은색
  var normalizedYawStabilityScores: [Double] {
    return taskData.avgAuxDatas.map { Double($0.avgYawStabilityScore) * (100.0 / 35.0) }
  }

  /// 정규화된 ML Snooze Score (졸음 점수) - 분홍색
  var normalizedMlSnoozeScores: [Double] {
    return taskData.avgAuxDatas.map { Double($0.avgMlSnoozeScore) * (100.0 / 40.0) }
  }

  func toggleExpanded() {
    withAnimation(.easeInOut(duration: 0.3)) {
      isExpanded.toggle()
    }
  }
}
