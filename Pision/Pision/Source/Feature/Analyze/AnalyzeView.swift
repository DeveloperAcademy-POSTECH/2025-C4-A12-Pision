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
        CustomNavigationbar(title: "자세 맞추기", titleColor: .W_00, buttonColor: .W_00)
        ScrollView {
          if let taskData = tasks.first { // 일단 지금은 저장된 tasks 중에서 맨 첫번째 시간의 task를 가져옴.
            AnalyzeBodyView(taskData: taskData)
          } else {
            Text("아직 테스크가 없습니다.")
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
        FocusTimeOverviewView(taskData: taskData)
        HourlyFocusChartView(taskData: taskData)
        AnalyzeDetailView(taskData: taskData)
      }
      .padding(.horizontal, 20)
      .padding(.top, 5)
    }
  }
}

// MARK: - 집중 개요 뷰
extension AnalyzeView {
  struct FocusTimeOverviewView: View {
    let taskData: TaskData
    
    var body: some View {
      VStack(alignment: .leading, spacing: 21) {
        // 시간 + 집중률 문장
        VStack(alignment: .leading, spacing: 15) {
          // 시작 ~ 종료 시간
          HStack {
            Text("\(taskData.startTime.formatted(date: .omitted, time: .shortened)) ~ \(taskData.endTime.formatted(date: .omitted, time: .shortened))")
              .font(.FontSystem.b1)
            Spacer()
          }
          // 당신의 집중률 ~ 글자박스
          VStack(alignment: .leading, spacing: 3) {
            (
              Text("당신의 집중률은 ")
                .font(.FontSystem.h2) +
              Text("\(Int(taskData.averageScore))%")
                .font(.FontSystem.h2)
                .bold()
            )
            .foregroundColor(Color.B_10)
            (
              Text("매우 준수한 상태")
                .font(.FontSystem.h2)
                .bold() +
              Text("입니다.")
                .font(.FontSystem.h2)
            )
            .foregroundColor(Color.B_10)
          }
        }
        // 프로그레스바
        ZStack {
          // 백그라운드 (전체 막대)
          Capsule()
            .fill(Color.BR_50)
            .frame(height: 8)
          
          // 채워진 부분 (프로그레스 값만큼만 width 조절)
          GeometryReader { geometry in
            Capsule()
              .fill(Color.BR_00)
              .frame(
                width: geometry.size.width * CGFloat(taskData.averageScore / 100),
                height: 8
              )
          }
        }
        .frame(height: 10)
        
        HStack(spacing: 40) {
          VStack(alignment: .leading) {
            HStack(spacing: 5){
              Rectangle()
                .fill(.BR_00)
                .frame(width: 12, height: 12)
                .cornerRadius(1.3)
              Text("집중시간")
                .font(.FontSystem.b1)
                .foregroundColor(Color.B_20)
            }
            Text("\(AnalyzeView.formatSeconds(Double(taskData.focusTime)))")
              .font(.FontSystem.h4)
              .foregroundColor(Color.BR_00)
              .fontWeight(.bold)
          }
          
          VStack(alignment: .leading) {
            HStack(spacing: 5){
              Rectangle()
                .fill(.BR_50)
                .frame(width: 12, height: 12)
                .cornerRadius(1.3)
              Text("전체시간")
                .font(.FontSystem.b1)
                .foregroundColor(Color.B_20)
            }
            Text("\(AnalyzeView.formatSeconds(Double(taskData.durationTime)))")
              .font(.FontSystem.h4)
              .fontWeight(.bold)
              .foregroundColor(Color.B_20)
          }
        }
      }
      .padding(20)
      .background(Color.W_00)
      .cornerRadius(16)
    }
  }
}

// MARK: - 시간별 집중도 바 차트 뷰
extension AnalyzeView {
  struct HourlyFocusChartView: View {
    let taskData: TaskData
    
    var body: some View {
      VStack(alignment: .leading, spacing: 0) {
        Text("상세 정보")
          .font(.headline)
          .foregroundColor(.secondary)
        
        VStack(alignment: .leading, spacing: 12) {
          Text("시간별 집중률")
            .font(.headline)
          
          ScrollView(.horizontal, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 8) {
              // 차트 부분
              HStack(spacing: 7.1) {
                ForEach(Array(taskData.focusRatio.enumerated()), id: \.offset) { idx, ratio in
                  ZStack {
                    Rectangle()
                      .fill(Color.BR_50)
                      .frame(width: 15.38, height: 95)
                      .cornerRadius(4)
                    VStack {
                      Spacer()
                      Rectangle()
                        .fill(Color.BR_20)
                        .frame(width: 15.38, height: CGFloat(ratio * (95.0 / 100.0)))
                        .cornerRadius(4)
                    }
                  }
                }
              }
              .frame(height: 95)
              .background(Color.BR_00)
              .padding(.leading, 7.1) // 왼쪽에만 16pt 여백
              // 라벨 부분 (10분)
              HStack() {
                ForEach(Array(taskData.focusRatio.enumerated()), id: \.offset) { idx, ratio in
                  Text((idx == 0 || (idx + 1) * 10 % 30 == 0) ? "\((idx + 1) * 10)분" : "")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(width: 30, height: 17)
                }
              }
            }
          }
          .frame(height: 115)
          
          HStack {
            Rectangle()
              .fill(.blue)
              .frame(width: 12, height: 12)
            Text("집중시간")
            
            Spacer()
            
            Rectangle()
              .fill(.gray.opacity(0.3))
              .frame(width: 12, height: 12)
            Text("공부시간")
          }
          .font(.caption)
        }
        .frame(height: 227)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
      }
    }
  }
}

extension AnalyzeView {
  struct AnalyzeDetailView: View {
    let taskData: TaskData
    
    var body: some View {
      VStack(spacing: 16) {
        CoreScoreSection(taskData: taskData)
        AuxScoreSection(taskData: taskData)
      }
    }
  }
}

// MARK: - CoreScore 드롭다운 뷰
extension AnalyzeView {
  struct CoreScoreSection: View {
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
              HStack {
                Text("CoreScore")
                  .font(.headline)
                  .foregroundColor(.primary)
                Image(systemName: "info.circle")
                  .foregroundColor(.secondary)
                  .font(.caption)
              }
              Text("실시간 정보로 집중도를 파악해요")
                .font(.caption)
                .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
              Text("\(String(format: "%.1f", taskData.averageCoreScore()))%")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.blue)
              
              Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                .foregroundColor(.secondary)
            }
          }
          .padding()
          .background(Color(.systemBackground))
          .cornerRadius(12)
          .shadow(radius: 2)
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

// MARK: - AuxScore 드롭다운 뷰
extension AnalyzeView {
  struct AuxScoreSection: View {
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
                  .font(.headline)
                  .foregroundColor(.primary)
                Image(systemName: "info.circle")
                  .foregroundColor(.secondary)
                  .font(.caption)
              }
              Text("세부적인 정보로 집중도를 파악해요")
                .font(.caption)
                .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
              Text("\(String(format: "%.1f", taskData.averageAuxScore()))%")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.blue)
              
              Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                .foregroundColor(.secondary)
            }
          }
          .padding()
          .background(Color(.systemBackground))
          .cornerRadius(12)
          .shadow(radius: 2)
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

// MARK: - 시간 포맷팅 함수
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
  
  let context = container.mainContext
  context.insert(TaskData.mock)
  
  return AnalyzeView()
    .modelContainer(container)
}
