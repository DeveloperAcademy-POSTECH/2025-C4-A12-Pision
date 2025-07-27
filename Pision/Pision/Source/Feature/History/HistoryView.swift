
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

  // 세션 단위로 그룹핑 (2분 이내 연속 측정)
  var groupedSessions: [[TaskData]] {
    var sessions: [[TaskData]] = []
    var currentGroup: [TaskData] = []
    let sorted = filteredTasks.sorted { $0.startTime < $1.startTime }
    
    for task in sorted {
      if let last = currentGroup.last {
        if task.startTime.timeIntervalSince(last.endTime) <= 120 {
          currentGroup.append(task)
        } else {
          sessions.append(currentGroup)
          currentGroup = [task]
        }
      } else {
        currentGroup.append(task)
      }
    }
    if !currentGroup.isEmpty {
      sessions.append(currentGroup)
    }
    return sessions
  }

  func summarizeSessions(_ sessions: [[TaskData]]) -> (totalFocus: Int, totalDuration: Int, sessionCount: Int) {
      var totalFocus = 0
      var totalDuration = 0
      var count = 0

      for session in sessions {
          guard let first = session.first, let last = session.last else { continue }
          let duration = Int(last.endTime.timeIntervalSince(first.startTime))
          totalDuration += duration
          count += 1

          // session 내부 집중률 평균 구함
          let totalFocusValue = session.reduce(0) { $0 + $1.focusTime }
          let totalDurationValue = session.reduce(0) { $0 + $1.durationTime }
          let focusRatio = totalDurationValue == 0 ? 0.0 : Double(totalFocusValue) / Double(totalDurationValue)
          let estimatedFocus = Int(Double(duration) * focusRatio)

          totalFocus += estimatedFocus
      }

      return (totalFocus, totalDuration, count)
  }

  var dailySummary: (avgFocus: Int, totalFocus: Int, totalDuration: Int, sessionCount: Int) {
      let (focus, duration, count) = summarizeSessions(groupedSessions)
      let avg = duration == 0 ? 0 : Int(Double(focus) / Double(duration) * 100)
      return (avg, focus, duration, count)
  }
  
  func mergeSession(_ group: [TaskData]) -> TaskData? {
      guard let first = group.first, let last = group.last else { return nil }

      let totalDuration = Int(last.endTime.timeIntervalSince(first.startTime))

      // 평균 집중률 비율 기반으로 실제 session duration에 맞춰 focus 추정
      let totalFocusValue = group.reduce(0) { $0 + $1.focusTime }
      let totalDurationValue = group.reduce(0) { $0 + $1.durationTime }
      let focusRatio = totalDurationValue == 0 ? 0.0 : Double(totalFocusValue) / Double(totalDurationValue)
      let estimatedFocus = Int(Double(totalDuration) * focusRatio)

      let allFocusRatios = group.flatMap { $0.focusRatio }
      let allCore = group.flatMap { $0.avgCoreDatas }
      let allAux = group.flatMap { $0.avgAuxDatas }

      let averageScore = focusRatio

      return TaskData(
          startTime: first.startTime,
          endTime: last.endTime,
          averageScore: Float(averageScore),
          focusRatio: allFocusRatios,
          focusTime: estimatedFocus,
          durationTime: totalDuration,
          snoozeImageDatas: [],
          avgCoreDatas: allCore,
          avgAuxDatas: allAux
      )
  }
}

// MARK: - View
extension HistoryView {
  var body: some View {
    ZStack {
      Image("background")
        .resizable()
        .ignoresSafeArea()
      VStack {
        HStack {
          HStack {
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
        
        ScrollView {
          VStack {
            FixedOverListView(
              avgFocus: dailySummary.avgFocus,
              focusTime: dailySummary.totalFocus,
              totalDuration: dailySummary.totalDuration,
              sessionCount: dailySummary.sessionCount
            )
          }
          VStack {
            HStack {
              Text("측정 리스트")
                .font(.FontSystem.h2)
                .foregroundStyle(.B_10)
                .padding(.leading)
                .padding(.top)
              Spacer()
            }
            ForEach(groupedSessions, id: \.first!.startTime) { group in
              if let merged = mergeSession(group) {
                HistoryRowView(task: merged)
              }
            }
          }
        }
        .onChange(of: selectedDate) { newValue in
          print("선택된 날짜: \(newValue)")
        }
      }
    }
  }
}

// MARK: - Func
extension HistoryView {
  
}

// MARK: - 예시 데이터
extension HistoryView {
  static var mock: TaskData {
    TaskData(
      startTime: Date(),
      endTime: Date().addingTimeInterval(4 * 60 * 60),
      averageScore: 78,
      focusRatio: Array(repeating: 80, count: 24),
      focusTime: 10800,
      durationTime: 14400,
      snoozeImageDatas: [],
      avgCoreDatas: [],
      avgAuxDatas: []
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
