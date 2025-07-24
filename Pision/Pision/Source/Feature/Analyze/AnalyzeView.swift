//
//  AnalyzeView.swift
//  Pision
//
//  Created by 여성일 on 7/14/25.
//

import SwiftUI
import Charts
import SwiftData

struct AnalyzeView: View {
  @Query(sort: \TaskData.startTime, order: .reverse) var tasks: [TaskData]
}

extension AnalyzeView {
  var body: some View {
    ZStack {
      Image(.background)
        .resizable()
        .ignoresSafeArea()
      
      VStack {
        CustomNavigationBar(title: "집중 분석")
        ScrollView {
          if let taskData = tasks.first { // 저장된 tasks 중에서 맨 첫번째 시간의 task를 가져옴.
            AnalyzeBodyView(taskData: taskData)
          } else {
            Text("데이터가 없습니다.")
              .foregroundColor(.gray)
          }
        }
      }
    }
    .navigationBarBackButtonHidden()
  }
}

extension AnalyzeView {
  struct AnalyzeBodyView: View {
    let taskData: TaskData
    
    var body: some View {
      VStack(spacing: 24) {
        FocusTimeOverviewView(taskData: taskData) // 집중 개요 뷰
        HourlyFocusChartView(taskData: taskData) // 시간별 집중도 뷰
        AnalyzeDetailView(taskData: taskData) // 측정 상세 뷰
      }
      .padding()
    }
  }
}

// MARK: - 집중 개요 뷰
extension AnalyzeView {
  struct FocusTimeOverviewView: View {
    let taskData: TaskData
    
    var body: some View {
      VStack(alignment: .leading, spacing: 12) {
        Text("시작 시간 \(taskData.startTime.formatted(date: .omitted, time: .shortened))")
        Text("끝 시간 \(taskData.endTime.formatted(date: .omitted, time: .shortened))")
        Text("집중시간 \(AnalyzeView.formatSeconds(Double(taskData.focusTime)))")
        Text("전체시간 \(AnalyzeView.formatSeconds(Double(taskData.durationTime)))")
        Text("집중률 \(Int(taskData.averageScore))%")
        
        VStack(alignment: .leading, spacing: 4) {
          Text("집중 시간 비율")
            .font(.subheadline)
            .foregroundColor(.secondary)
          
          ProgressView(value: taskData.averageScore / 100)
            .progressViewStyle(LinearProgressViewStyle(tint: .blue))
            .frame(height: 12)
            .background(Color(.systemGray5))
            .clipShape(Capsule())
          
          HStack {
            Text("0%")
              .font(.caption)
              .foregroundColor(.gray)
            Spacer()
            Text("100%")
              .font(.caption)
              .foregroundColor(.gray)
          }
        }
        .padding(.top, 8)
      }
    }
  }
}

// MARK: - 시간별 집중도 바 차트 뷰
extension AnalyzeView {
  struct HourlyFocusChartView: View {
    let taskData: TaskData
    
    var body: some View {
      VStack(alignment: .leading) {
        Text("시간별 집중도")
          .font(.headline)
        
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(alignment: .bottom, spacing: 4) {
            ForEach(Array(taskData.focusRatio.enumerated()), id: \.offset) { idx, ratio in
              VStack {
                Rectangle()
                  .frame(width: 10, height: CGFloat(ratio))
                  .foregroundColor(.blue)
                Text("\(Int(ratio) / 10)분")
                  .font(.caption)
              }
            }
          }
        }
      }
    }
  }
}

extension AnalyzeView {
  struct AnalyzeDetailView: View {
    let taskData: TaskData
    
    var body: some View {
      VStack(alignment: .leading) {
        HStack {
          Text("측정 상세")
            .font(.headline)
          Spacer()
        }
        CoreScoreSection(taskData: taskData)
        AuxScoreSection(taskData: taskData)
      }
    }
  }
}

// MARK: - CoreScore 꺾은선 그래프 뷰
extension AnalyzeView {
  struct CoreScoreSection: View {
    let taskData: TaskData
    
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
      VStack(alignment: .leading, spacing: 8) {
        Text("Core Score")
          .font(.headline)
        Text("평균 \(Int(taskData.averageCoreScore())) 점")
        
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
          .chartLegend(.visible) // 범례 표시
          .frame(width: 400, height: 250)
        }
      }
    }
  }
}

// MARK: - AuxScore 꺾은선 그래프
extension AnalyzeView {
  struct AuxScoreSection: View {
    let taskData: TaskData
    
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
      VStack(alignment: .leading, spacing: 8) {
        Text("Aux Score")
          .font(.headline)
        Text("평균 \(Int(taskData.averageAuxScore())) 점")
        
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
    }
  }
}

// MARK: - 몇 시간 몇 분으로 시간 포맷팅하는 함수
extension AnalyzeView {
  private static func formatSeconds(_ time: TimeInterval) -> String {
    let minutes = Int(time) / 60
    let hours = minutes / 60
    let remainingMinutes = minutes % 60
    return "\(hours)시간 \(remainingMinutes)분"
  }
}

#Preview {
  let container = try! ModelContainer(
    for: TaskData.self,
    configurations: ModelConfiguration(isStoredInMemoryOnly: true)
  )
  
  // Mock 데이터 추가
  let context = container.mainContext
  context.insert(TaskData.mock)
  
  return AnalyzeView()
    .modelContainer(container)
}
