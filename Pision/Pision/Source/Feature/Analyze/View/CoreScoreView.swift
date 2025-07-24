//
//  CoreScoreView.swift
//  Pision
//
//  Created by rundo on 7/25/25.
//

import SwiftUI
import Charts

// MARK: - CoreScore 드롭다운 뷰
extension AnalyzeView {
  struct CoreScoreView: View {
    let taskData: TaskData
    @State private var isExpanded = false
    
    struct ScoreDetailEntry: Identifiable {
      let id = UUID()
      let index: Int
      let value: Double
      let category: String
    }
    
    var coreScoreEntries: [ScoreDetailEntry] {
      guard !taskData.avgCoreDatas.isEmpty else { return [] }
      var entries: [ScoreDetailEntry] = []
      
      for (idx, score) in taskData.avgCoreDatas.enumerated() {
        entries.append(ScoreDetailEntry(index: idx + 1, value: Double(score.avgYawScore) * 2.5, category: "avgYawScore"))
        entries.append(ScoreDetailEntry(index: idx + 1, value: Double(score.avgEyeOpenScore) * 4.0, category: "avgEyeOpenScore"))
        entries.append(ScoreDetailEntry(index: idx + 1, value: Double(score.avgEyeClosedScore) * 5.0, category: "avgEyeClosedScore"))
        entries.append(ScoreDetailEntry(index: idx + 1, value: Double(score.avgBlinkFrequency) * (100.0 / 15.0), category: "avgBlinkFrequency"))
      }
      
      return entries
    }
    
    var body: some View {
      VStack(alignment: .leading, spacing: 0) {
        Button(action: {
          withAnimation(.easeInOut(duration: 0.3)) {
            isExpanded.toggle()
          }
        }) {
          HStack {
            VStack(alignment: .leading, spacing: 4) {
              HStack(spacing: 8) {
                Text("CoreScore")
                  .font(.FontSystem.h4)
                Image("info")
              }
              Text("실시간 정보로 집중도를 파악해요")
                .font(.FontSystem.btn)
                .foregroundColor(Color.B_20)
            }
            
            Spacer()
            
            HStack(spacing: 16) {
              Text("\(String(format: "%.1f", taskData.averageCoreScore()))%")
                .font(.spoqaHanSansNeo(type: .bold, size: 28))
                .foregroundColor(Color.BR_00)

              Image(isExpanded ? "dropUp" : "dropDown")
            }
          }
          .padding(20)
          .background(Color.W_00)
          .cornerRadius(16)
        }
        .buttonStyle(PlainButtonStyle())
        
        if isExpanded {
          VStack(alignment: .leading, spacing: 8) {
            ScrollView(.horizontal) {
              Chart {
                ForEach(coreScoreEntries) { entry in
                  LineMark(
                    x: .value("Index", entry.index),
                    y: .value("Score", entry.value)
                  )
                  .interpolationMethod(.catmullRom)
                  .foregroundStyle(by: .value("Category", entry.category))
                  
                  PointMark(
                    x: .value("Index", entry.index),
                    y: .value("Score", entry.value)
                  )
                  .symbolSize(20)
                  .foregroundStyle(by: .value("Category", entry.category))
                }
              }
              .chartYScale(domain: 0...100)
              .chartLegend(.visible)
              .frame(width: 400, height: 250)
            }
          }
          .padding()
          .background(Color(.systemGray6))
          .cornerRadius(12)
          .transition(.opacity.combined(with: .scale))
        }
      }
    }
  }
}
