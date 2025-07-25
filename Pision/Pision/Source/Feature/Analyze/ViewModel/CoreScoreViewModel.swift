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
    generateEntries()
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
    return taskData.avgCoreDatas.map { Double($0.avgYawScore) * 2.5 }
  }

  /// 정규화된 Eye Open Score (EAR 비율) - 검은색
  var normalizedEyeOpenScores: [Double] {
    return taskData.avgCoreDatas.map { Double($0.avgEyeOpenScore) * 4.0 }
  }

  /// 정규화된 Eye Closed Score (눈 EAR) - 분홍색
  var normalizedEyeClosedScores: [Double] {
    return taskData.avgCoreDatas.map { Double($0.avgEyeClosedScore) * 5.0 }
  }

  /// 정규화된 Blink Frequency (깜빡임 빈도) - 초록색
  var normalizedBlinkFrequencies: [Double] {
    return taskData.avgCoreDatas.map { Double($0.avgBlinkFrequency) * (100.0 / 15.0) }
  }

  func toggleExpanded() {
    withAnimation(.easeInOut(duration: 0.3)) {
      isExpanded.toggle()
    }
  }

  private func generateEntries() {
    guard !taskData.avgCoreDatas.isEmpty else { return }

    var result: [CoreScoreEntry] = []

    for (idx, score) in taskData.avgCoreDatas.enumerated() {
      result.append(CoreScoreEntry(index: idx + 1, value: Double(score.avgYawScore) * 2.5, category: "avgYawScore"))
      result.append(CoreScoreEntry(index: idx + 1, value: Double(score.avgEyeOpenScore) * 4.0, category: "avgEyeOpenScore"))
      result.append(CoreScoreEntry(index: idx + 1, value: Double(score.avgEyeClosedScore) * 5.0, category: "avgEyeClosedScore"))
      result.append(CoreScoreEntry(index: idx + 1, value: Double(score.avgBlinkFrequency) * (100.0 / 15.0), category: "avgBlinkFrequency"))
    }

    self.entries = result
  }
}
