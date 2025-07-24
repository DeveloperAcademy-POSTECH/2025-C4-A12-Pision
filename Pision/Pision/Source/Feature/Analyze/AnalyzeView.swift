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
      VStack(spacing: 8) {
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
                .font(.spoqaHanSansNeo(type: .regular, size: 20)) +
              Text("\(Int(taskData.averageScore))%")
                .font(.FontSystem.h2)
            )
            .foregroundColor(Color.B_10)
            (
              Text("매우 준수한 상태")
                .font(.FontSystem.h2) +
              Text("입니다.")
                .font(.spoqaHanSansNeo(type: .regular, size: 20))
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
              Text("공부시간")
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
      VStack(alignment: .leading, spacing: 8) {
        Text("상세 정보")
          .font(.FontSystem.h2)
          .foregroundColor(.B_00)
        
        VStack(alignment: .leading, spacing: 20) {
          Text("시간별 집중률")
            .font(.FontSystem.h4)
          // 왼쪽 지표 + 스크롤 화면
          HStack(spacing: 5){
            VStack {
              Text("100")
                .font(Font.custom("Spoqa Han Sans Neo", size: 12))
//              Spacer()
//              Text("평균")
//                .font(Font.custom("Spoqa Han Sans Neo", size: 12))
//                .foregroundColor(Color.BR_00)
              Spacer()
              Text("0")
                .font(Font.custom("Spoqa Han Sans Neo", size: 12))

            }
            .foregroundColor(Color.B_00)
            .padding(.bottom, 5) // 0과 가로선 맞추기
            ScrollView(.horizontal, showsIndicators: false) {
              // 차트 + 10분
              VStack(alignment: .leading, spacing: 2) {
                // 차트 부분
                ZStack(alignment: .leading) {
                  // 가로선 배경
                  VStack {
                    Rectangle()
                      .fill(Color.BR_50)
                      .frame(height: 1)
                    Spacer()
                    Rectangle()
                      .fill(Color.BR_50)
                      .frame(height: 1)
                    Spacer()
                    Rectangle()
                      .fill(Color.BR_50)
                      .frame(height: 1)
                    Spacer()
                    Rectangle()
                      .fill(Color.BR_50)
                      .frame(height: 1)
                    Spacer()
                    Rectangle()
                      .fill(Color.BR_50)
                      .frame(height: 1)
                  }
                  // 그래프 막대 부분들
                  HStack(spacing: 7.1) {
                    ForEach(Array(taskData.focusRatio.enumerated()), id: \.offset) { idx, ratio in
                      ZStack {
                        Rectangle() // 회색 배경 캡슐
                          .fill(Color.BR_50)
                          .frame(width: 15.38, height: 95)
                          .cornerRadius(4)
                        VStack { // 파란 점수 캡슐
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
                  .padding(.leading, 7.1) // 왼쪽에만 16pt 여백
                }

                // 라벨 부분 (10분)
                HStack(spacing: 16) {
                  Text("10분")
                    .font(.spoqaHanSansNeo(type: .regular, size: 12))
                  HStack(spacing: 32.3) {
                    ForEach(Array(taskData.focusRatio.enumerated()), id: \.offset) { idx, ratio in
                      if idx >= 2 && (idx + 1) * 10 % 30 == 0 {
                        HStack {
                          Text("\((idx + 1) * 10)분")
                            .font(.spoqaHanSansNeo(type: .regular, size: 12))
                        }
                        .frame(width: 35, height: 12)
//                        .background(Color.BR_00)
                      }
                    }
                  }
//                  .background(.gray)
                }
                .padding(.leading, 2) // 10분 가운데 맞추기
              }
              .padding(.top, 13) // 100과 맞추기 위한 윗 패딩
            }
            .frame(height: 115)
          }

          HStack {
            Spacer()
            HStack(spacing: 5) {
              Rectangle()
                .fill(.BR_20)
                .frame(width: 10, height: 10)
                .cornerRadius(1.3)
              Text("집중시간")
                .font(.FontSystem.btn).bold()
                .foregroundColor(Color.B_20)
            }
            
            Spacer().frame(width: 50 )
            
            HStack(spacing: 5) {
              Rectangle()
                .fill(.BR_50)
                .frame(width: 10, height: 10)
                .cornerRadius(1.3)
              Text("공부시간")
                .font(.FontSystem.btn).bold()
                .foregroundColor(Color.B_20)
            }
            Spacer()
          }
        }
        .padding(20)
        .background(Color.W_00)
        .cornerRadius(16)
      }
      .padding(.top, 13)
    }
  }
}

extension AnalyzeView {
  struct AnalyzeDetailView: View {
    let taskData: TaskData
    
    var body: some View {
      VStack(spacing: 8) {
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
