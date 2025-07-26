//
//  CoreScoreViewModel.swift
//  Pision
//
//  Created by rundo on 7/25/25.
//

import Foundation
import SwiftData
import SwiftUI

struct CoreScoreEntry: Identifiable {
  let id = UUID()
  let index: Int
  let value: Double
  let category: String
}

@MainActor
class CoreScoreViewModel: ObservableObject {
  @Published var isExpanded: Bool = false
  @Published private(set) var entries: [CoreScoreEntry] = []

  let taskData: TaskData

  init(taskData: TaskData) {
    self.taskData = taskData
  }

  var averageScoreText: String {
    String(format: "%.1f", taskData.averageCoreScore())
  }

  /// 데이터 포인트 개수
  var dataPointCount: Int {
    return taskData.avgCoreDatas.count
  }

  /// 정규화된 Yaw Score (고개 자세) - 파란색
  var normalizedYawScores: [Double] {
    return taskData.avgCoreDatas.map { Double($0.avgYawScore) * (100.0 / 25.0) }
  }

  /// 정규화된 Eye Open Score (EAR 비율) - 검은색
  var normalizedEyeOpenScores: [Double] {
    return taskData.avgCoreDatas.map { Double($0.avgEyeOpenScore) * (100.0 / 30.0) }
  }

  /// 정규화된 Eye Closed Score (눈 EAR) - 분홍색
  var normalizedEyeClosedScores: [Double] {
    return taskData.avgCoreDatas.map { Double($0.avgEyeClosedScore) * (100.0 / 20.0) }
  }

  /// 정규화된 Blink Frequency (깜빡임 빈도) - 초록색
  var normalizedBlinkFrequencies: [Double] {
    return taskData.avgCoreDatas.map { Double($0.avgBlinkFrequency) * (100.0 / 25.0) }
  }

  func toggleExpanded() {
    withAnimation(.easeInOut(duration: 0.3)) {
      isExpanded.toggle()
    }
  }
}
