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
  @State var isNext:Bool = false
  
  var filteredTasks: [TaskData] {
    let startOfDay = Calendar.current.startOfDay(for: selectedDate)
    let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
    return tasks.filter {
      $0.startTime >= startOfDay && $0.startTime < endOfDay
    }
  }
  
  var dailySummary: (avgFocus: Int, totalFocus: Int, totalDuration: Int, sessionCount: Int) {
    let totalFocus = filteredTasks.reduce(0) { $0 + $1.focusTime }
    let totalDuration = filteredTasks.reduce(0) { $0 + $1.durationTime }
    let avg = totalDuration == 0 ? 0 : Int(Double(totalFocus) / Double(totalDuration) * 100)
    return (avg, totalFocus, totalDuration, filteredTasks.count)
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
            ForEach(filteredTasks, id: \.startTime) { task in
              Button {
                isNext = true
//                print("\(task.startTime)")
              } label: {
                HistoryRowView(task: task)
              }
            }
          }
        }
        .onChange(of: selectedDate) { _, newValue in
          print("선택된 날짜: \(newValue)")
        }
      }
    }
  }
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
