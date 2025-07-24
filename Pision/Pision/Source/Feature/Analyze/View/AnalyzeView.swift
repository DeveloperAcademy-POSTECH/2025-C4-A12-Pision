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
      VStack(spacing: 8) {
        FocusTimeOverviewView(taskData: taskData)
        HourlyFocusChartView(taskData: taskData)
        CoreScoreView(taskData: taskData)
        AuxScoreView(taskData: taskData)
      }
      .padding(.horizontal, 20)
      .padding(.top, 5)
    }
  }
}

// MARK: - 시간 포맷팅 함수
extension AnalyzeView {
  static func formatSeconds(_ time: TimeInterval) -> String {
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
