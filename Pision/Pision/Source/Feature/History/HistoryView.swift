//
//  HistoryView.swift
//  Pision
//
//  Created by YONGWON SEO on 7/21/25.
//

import SwiftUI
import SwiftData

// MARK: - Var
struct HistoryView: View {
  @Query(sort: \TaskData.startTime, order: .reverse) var tasks: [TaskData]
  
  @State var selectedDate: Date = Date()
  @State var calendarMode: CalendarView.ViewMode = .daily
  
  var filteredTasks: [TaskData] {
    let startOfDay = Calendar.current.startOfDay(for: selectedDate)
    let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
    return tasks.filter {
      $0.startTime >= startOfDay && $0.startTime < endOfDay
    }
  }
  
  var dailySummary: (avgFocus: Int, totalFocus: Int, totalDuration: Int, sessionCount: Int) {
    guard !filteredTasks.isEmpty else { return (0, 0, 0, 0) }
    let totalFocus = filteredTasks.reduce(0) { $0 + $1.focusTime }
    let totalDuration = filteredTasks.reduce(0) { $0 + $1.durationTime }
    let sessionCount = filteredTasks.count
    let avgFocus = Int(Double(totalFocus) / Double(totalDuration) * 100)
    return (avgFocus, totalFocus,  totalDuration, sessionCount)
  }
}


// MARK: - View
extension HistoryView {
  var body: some View {
    ZStack{
      Image("background")
        .resizable()
        .ignoresSafeArea()
      VStack{
        HStack{
          HStack{
            Text("닉네임")
              .font(.FontSystem.b2)
              .foregroundStyle(.B_20)
            Spacer()
            Text("기록")
              .font(.FontSystem.h2)
              .foregroundStyle(.B_00)
            Spacer()
            Image(systemName: "trophy")
              .foregroundStyle(.BR_00)
            Image(systemName: "gearshape")
              .foregroundStyle(.BR_00)
          }.padding(10)
        }
        .padding(.top)
        .padding(.leading)
        .padding(.trailing)
        CalendarView(selectedDate: $selectedDate, selectedMode: $calendarMode)
          .frame(height: calendarMode == .daily ? 120 : 330)
        ScrollView{
          VStack{
            FixedOverListView(
              avgFocus: dailySummary.avgFocus,
              focusTime: dailySummary.totalFocus,
              totalDuration: dailySummary.totalDuration,
              sessionCount: dailySummary.sessionCount
            )
          }
          VStack {
            HStack{
              Text("측정 리스트")
                .font(.FontSystem.h2)
                .foregroundStyle(.B_10)
                .padding(.leading)
                .padding(.top)
              Spacer()
            }
            ForEach(filteredTasks) { task in
              HistoryRowView(task: task)
            }
          }
        }
        .onChange(of:selectedDate) { newValue in
          print("선택된 날짜: \(newValue)")
        }
      }
    }
  }
}

// MARK: - Func
extension HistoryView {
  
}

extension HistoryView {
  static var mock: TaskData {
    TaskData(
      startTime: Date(),
      endTime: Date().addingTimeInterval(4 * 60 * 60), // 4시간 후
      averageScore: 78,
      focusRatio: [
        85, 90, 75, 80, 70, 65,  // 첫 1시간: 높은 집중도
        60, 55, 50, 45, 40, 35,  // 둘째 시간: 집중도 하락
        30, 35, 40, 50, 60, 70,  // 셋째 시간: 회복
        75, 80, 85, 90, 88, 82   // 넷째 시간: 안정적 집중
      ], // 24개 (10분 단위)
      focusTime: 10800, // 3시간 집중 (초)
      durationTime: 14400, // 4시간 전체 (초)
      avgCoreDatas: [
        // 첫 번째 시간 (6개)
        AvgCoreScore(avgYawScore: 35, avgEyeOpenScore: 45, avgEyeClosedScore: 10, avgBlinkFrequency: 8, avgCoreScore: 85),
        AvgCoreScore(avgYawScore: 38, avgEyeOpenScore: 48, avgEyeClosedScore: 8, avgBlinkFrequency: 7, avgCoreScore: 90),
        AvgCoreScore(avgYawScore: 32, avgEyeOpenScore: 42, avgEyeClosedScore: 12, avgBlinkFrequency: 9, avgCoreScore: 75),
        AvgCoreScore(avgYawScore: 36, avgEyeOpenScore: 46, avgEyeClosedScore: 9, avgBlinkFrequency: 8, avgCoreScore: 80),
        AvgCoreScore(avgYawScore: 30, avgEyeOpenScore: 40, avgEyeClosedScore: 14, avgBlinkFrequency: 10, avgCoreScore: 70),
        AvgCoreScore(avgYawScore: 28, avgEyeOpenScore: 38, avgEyeClosedScore: 16, avgBlinkFrequency: 11, avgCoreScore: 65),
        
        // 두 번째 시간 (6개)
        AvgCoreScore(avgYawScore: 25, avgEyeOpenScore: 35, avgEyeClosedScore: 18, avgBlinkFrequency: 12, avgCoreScore: 60),
        AvgCoreScore(avgYawScore: 22, avgEyeOpenScore: 32, avgEyeClosedScore: 20, avgBlinkFrequency: 13, avgCoreScore: 55),
        AvgCoreScore(avgYawScore: 20, avgEyeOpenScore: 30, avgEyeClosedScore: 22, avgBlinkFrequency: 14, avgCoreScore: 50),
        AvgCoreScore(avgYawScore: 18, avgEyeOpenScore: 28, avgEyeClosedScore: 24, avgBlinkFrequency: 15, avgCoreScore: 45),
        AvgCoreScore(avgYawScore: 16, avgEyeOpenScore: 26, avgEyeClosedScore: 26, avgBlinkFrequency: 16, avgCoreScore: 40),
        AvgCoreScore(avgYawScore: 15, avgEyeOpenScore: 24, avgEyeClosedScore: 28, avgBlinkFrequency: 17, avgCoreScore: 35),
        
        // 세 번째 시간 (6개)
        AvgCoreScore(avgYawScore: 17, avgEyeOpenScore: 26, avgEyeClosedScore: 26, avgBlinkFrequency: 16, avgCoreScore: 30),
        AvgCoreScore(avgYawScore: 20, avgEyeOpenScore: 30, avgEyeClosedScore: 22, avgBlinkFrequency: 14, avgCoreScore: 35),
        AvgCoreScore(avgYawScore: 24, avgEyeOpenScore: 34, avgEyeClosedScore: 18, avgBlinkFrequency: 12, avgCoreScore: 40),
        AvgCoreScore(avgYawScore: 28, avgEyeOpenScore: 38, avgEyeClosedScore: 15, avgBlinkFrequency: 10, avgCoreScore: 50),
        AvgCoreScore(avgYawScore: 32, avgEyeOpenScore: 42, avgEyeClosedScore: 12, avgBlinkFrequency: 9, avgCoreScore: 60),
        AvgCoreScore(avgYawScore: 35, avgEyeOpenScore: 45, avgEyeClosedScore: 10, avgBlinkFrequency: 8, avgCoreScore: 70),
        
        // 네 번째 시간 (6개)
        AvgCoreScore(avgYawScore: 37, avgEyeOpenScore: 47, avgEyeClosedScore: 8, avgBlinkFrequency: 7, avgCoreScore: 75),
        AvgCoreScore(avgYawScore: 39, avgEyeOpenScore: 49, avgEyeClosedScore: 6, avgBlinkFrequency: 6, avgCoreScore: 80),
        AvgCoreScore(avgYawScore: 40, avgEyeOpenScore: 50, avgEyeClosedScore: 5, avgBlinkFrequency: 5, avgCoreScore: 85),
        AvgCoreScore(avgYawScore: 42, avgEyeOpenScore: 52, avgEyeClosedScore: 4, avgBlinkFrequency: 4, avgCoreScore: 90),
        AvgCoreScore(avgYawScore: 40, avgEyeOpenScore: 50, avgEyeClosedScore: 6, avgBlinkFrequency: 6, avgCoreScore: 88),
        AvgCoreScore(avgYawScore: 38, avgEyeOpenScore: 48, avgEyeClosedScore: 8, avgBlinkFrequency: 7, avgCoreScore: 82)
      ],
      avgAuxDatas: [
        // 첫 번째 시간 (6개)
        AvgAuxScore(avgBlinkScore: 7, avgYawStabilityScore: 20, avgMlSnoozeScore: 15, avgAuxScore: 85),
        AvgAuxScore(avgBlinkScore: 6, avgYawStabilityScore: 22, avgMlSnoozeScore: 16, avgAuxScore: 90),
        AvgAuxScore(avgBlinkScore: 8, avgYawStabilityScore: 18, avgMlSnoozeScore: 13, avgAuxScore: 75),
        AvgAuxScore(avgBlinkScore: 7, avgYawStabilityScore: 19, avgMlSnoozeScore: 14, avgAuxScore: 80),
        AvgAuxScore(avgBlinkScore: 9, avgYawStabilityScore: 16, avgMlSnoozeScore: 12, avgAuxScore: 70),
        AvgAuxScore(avgBlinkScore: 10, avgYawStabilityScore: 15, avgMlSnoozeScore: 11, avgAuxScore: 65),
        
        // 두 번째 시간 (6개)
        AvgAuxScore(avgBlinkScore: 11, avgYawStabilityScore: 14, avgMlSnoozeScore: 10, avgAuxScore: 60),
        AvgAuxScore(avgBlinkScore: 12, avgYawStabilityScore: 13, avgMlSnoozeScore: 9, avgAuxScore: 55),
        AvgAuxScore(avgBlinkScore: 13, avgYawStabilityScore: 12, avgMlSnoozeScore: 8, avgAuxScore: 50),
        AvgAuxScore(avgBlinkScore: 14, avgYawStabilityScore: 11, avgMlSnoozeScore: 7, avgAuxScore: 45),
        AvgAuxScore(avgBlinkScore: 15, avgYawStabilityScore: 10, avgMlSnoozeScore: 6, avgAuxScore: 40),
        AvgAuxScore(avgBlinkScore: 16, avgYawStabilityScore: 9, avgMlSnoozeScore: 5, avgAuxScore: 35),
        
        // 세 번째 시간 (6개)
        AvgAuxScore(avgBlinkScore: 15, avgYawStabilityScore: 10, avgMlSnoozeScore: 6, avgAuxScore: 30),
        AvgAuxScore(avgBlinkScore: 14, avgYawStabilityScore: 11, avgMlSnoozeScore: 7, avgAuxScore: 35),
        AvgAuxScore(avgBlinkScore: 13, avgYawStabilityScore: 12, avgMlSnoozeScore: 8, avgAuxScore: 40),
        AvgAuxScore(avgBlinkScore: 11, avgYawStabilityScore: 14, avgMlSnoozeScore: 10, avgAuxScore: 50),
        AvgAuxScore(avgBlinkScore: 9, avgYawStabilityScore: 16, avgMlSnoozeScore: 12, avgAuxScore: 60),
        AvgAuxScore(avgBlinkScore: 8, avgYawStabilityScore: 18, avgMlSnoozeScore: 13, avgAuxScore: 70),
        
        // 네 번째 시간 (6개)
        AvgAuxScore(avgBlinkScore: 7, avgYawStabilityScore: 19, avgMlSnoozeScore: 14, avgAuxScore: 75),
        AvgAuxScore(avgBlinkScore: 6, avgYawStabilityScore: 20, avgMlSnoozeScore: 15, avgAuxScore: 80),
        AvgAuxScore(avgBlinkScore: 5, avgYawStabilityScore: 22, avgMlSnoozeScore: 16, avgAuxScore: 85),
        AvgAuxScore(avgBlinkScore: 4, avgYawStabilityScore: 24, avgMlSnoozeScore: 18, avgAuxScore: 90),
        AvgAuxScore(avgBlinkScore: 5, avgYawStabilityScore: 22, avgMlSnoozeScore: 16, avgAuxScore: 88),
        AvgAuxScore(avgBlinkScore: 6, avgYawStabilityScore: 20, avgMlSnoozeScore: 15, avgAuxScore: 82)
      ]
    )
  }
}


#Preview {
  let container = try! ModelContainer(
    for: TaskData.self,
    configurations: ModelConfiguration(isStoredInMemoryOnly: true)
  )
  
  let context = container.mainContext
  context.insert(HistoryView.mock)
  
  return HistoryView(selectedDate: Date())
    .modelContainer(container)
}
