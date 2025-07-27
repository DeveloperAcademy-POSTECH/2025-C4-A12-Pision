//
//  HomeView.swift
//  Pision
//
//  Created by YONGWON SEO on 7/26/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
  @Query private var todayTasks: [TaskData]

  init() {
    let startOfToday = Calendar.current.startOfDay(for: Date())
    let endOfToday = Calendar.current.date(byAdding: .day, value: 1, to: startOfToday)!

    _todayTasks = Query(
      filter: #Predicate<TaskData> {
        $0.startTime >= startOfToday && $0.startTime < endOfToday
      },
      sort: [SortDescriptor(\.startTime, order: .reverse)]
    )
  }

  var totalFocusTime: Int {
    todayTasks.map { $0.focusTime }.reduce(0, +)
  }

  var body: some View {
    ZStack {
      Image("background")
        .resizable()
        .ignoresSafeArea()
      VStack(spacing: 24) {
        VStack{
          HStack{
            HStack{
              Text("닉네임")
                .font(.FontSystem.b2)
                .foregroundStyle(.B_20)
              Spacer()
              Image(systemName: "trophy")
                .foregroundStyle(.BR_00)
              Image(systemName: "gearshape")
                .foregroundStyle(.BR_00)
            }.padding(10)
          }
        }
        .padding(.top)
        .padding(.leading)
        .padding(.trailing)
        VStack{

          Text("오늘 집중 시간은")
            .font(.FontSystem.h1)
            .foregroundStyle(.BR_00)

          Text("\(secondsToHourMinute(correctedFocusTimeToday)) 이에요")
            .font(.FontSystem.h1)
            .foregroundStyle(.BR_00)
            

          Text("조금 더 집중할 수 있는 환경을\n만들어 보아요!")
            .font(.FontSystem.b1)
            .multilineTextAlignment(.center)
            .foregroundStyle(.BR_00)
        }
        
        Spacer()
        VStack{
            Image(systemName: "pause.circle.fill") // 임시 이미지
              .resizable()
              .frame(width: 180, height: 180)
              .foregroundStyle(.blue)
        }
        Spacer()

        VStack(alignment: .leading) {
          Text("최근 측정")
            .font(.FontSystem.h3)
            .foregroundStyle(.B_00)
            .padding(.horizontal)

          if let latestTask = todayTasks.first {
            HomeRowView(task: latestTask)
              .frame(height: 140) // HomeRowView의 고정 예상 높이
          } else {
            Text("아직 오늘 측정된 기록이 없어요.")
              .font(.FontSystem.b2)
              .foregroundStyle(.B_30)
              .frame(height: 120) // HomeRowView의 고정 예상 높이
              .frame(maxWidth: .infinity)
              .padding()
              .background(RoundedRectangle(cornerRadius: 12).fill(.white))
              .padding(.horizontal)
          }
        }
        Spacer()
        Spacer()
        Spacer()
      }
    }
  }

  // MARK: - Helper
  func secondsToHourMinute(_ seconds: Int) -> String {
    let hours = seconds / 3600
    let minutes = (seconds % 3600) / 60
    return "\(hours)시간 \(minutes)분"
  }
  
  var correctedFocusTimeToday: Int {
    // 1. 오늘 날짜 기준으로 필터링
    let startOfDay = Calendar.current.startOfDay(for: Date())
    let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
    let filtered = todayTasks.filter { $0.startTime >= startOfDay && $0.startTime < endOfDay }

    // 2. TaskData들을 시작 순으로 정렬
    let sorted = filtered.sorted { $0.startTime < $1.startTime }

    // 3. 세션 단위로 그룹핑 (2분 이내 연결)
    var sessions: [[TaskData]] = []
    var currentSession: [TaskData] = []

    for task in sorted {
      if let last = currentSession.last {
        if task.startTime.timeIntervalSince(last.endTime) <= 120 {
          currentSession.append(task)
        } else {
          sessions.append(currentSession)
          currentSession = [task]
        }
      } else {
        currentSession = [task]
      }
    }
    if !currentSession.isEmpty {
      sessions.append(currentSession)
    }

    // 4. 각 세션에 대해 focusTime 추정
    var totalFocus = 0
    for session in sessions {
      guard let first = session.first, let last = session.last else { continue }

      let sessionDuration = Int(last.endTime.timeIntervalSince(first.startTime))
      let rawFocus = session.reduce(0) { $0 + $1.focusTime }
      let rawDuration = session.reduce(0) { $0 + $1.durationTime }

      let ratio = rawDuration == 0 ? 0.0 : Double(rawFocus) / Double(rawDuration)
      let estimatedFocus = Int(Double(sessionDuration) * ratio)

      totalFocus += estimatedFocus
    }

    return totalFocus
  }
}


// MARK: - 예시 데이터
extension HomeView {
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
      snoozeImageDatas: [],
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
  context.insert(HomeView.mock)

  return HomeView().modelContainer(container)
}

#Preview {
  HomeView()
}
