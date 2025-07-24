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
