//
//  AuxScoreView.swift
//  Pision
//
//  Created by rundo on 7/25/25.
//

import SwiftUI
import Charts

// MARK: - AuxScore 드롭다운 뷰
extension AnalyzeView {
  struct AuxScoreView: View {
    let taskData: TaskData
    @State private var isExpanded = false
    
    struct ScoreDetailEntry: Identifiable {
      let id = UUID()
      let index: Int
      let value: Double
      let category: String
    }
    
    var auxScoreEntries: [ScoreDetailEntry] {
      guard !taskData.avgAuxDatas.isEmpty else { return [] }
      var entries: [ScoreDetailEntry] = []
      
      for (idx, score) in taskData.avgAuxDatas.enumerated() {
        entries.append(ScoreDetailEntry(index: idx + 1, value: Double(score.avgBlinkScore) * 4.0, category: "avgBlinkScore"))
        entries.append(ScoreDetailEntry(index: idx + 1, value: Double(score.avgYawStabilityScore) * 4.0, category: "avgYawStabilityScore"))
        entries.append(ScoreDetailEntry(index: idx + 1, value: Double(score.avgMlSnoozeScore) * 2.0, category: "avgMlSnoozeScore"))
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
              HStack {
                Text("AuxScore")
                  .font(.FontSystem.h4)
                Image("info")
              }
              Text("세부적인 정보로 집중도를 파악해요")
                .font(.FontSystem.btn)
                .foregroundColor(Color.B_20)
            }
            
            Spacer()
            
            HStack(spacing: 16) {
              Text("\(String(format: "%.1f", taskData.averageAuxScore()))%")
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
                ForEach(auxScoreEntries) { entry in
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
              .frame(width: 600, height: 250)
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
