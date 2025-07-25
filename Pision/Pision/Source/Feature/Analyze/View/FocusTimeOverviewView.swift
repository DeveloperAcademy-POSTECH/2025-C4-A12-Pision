//
//  FocusTimeOverviewView.swift
//  Pision
//
//  Created by rundo on 7/25/25.
//

import SwiftUI
import SwiftData

extension AnalyzeView {
  // MARK: - 집중 개요 뷰
  struct FocusTimeOverviewView: View {
    let taskData: TaskData

    var body: some View {
      VStack(alignment: .leading, spacing: 21) {
        timeAndScoreText
        progressBar
        focusAndTotalTime
      }
      .padding(20)
      .background(Color.W_00)
      .cornerRadius(16)
    }

    // MARK: - 시작~종료 시간 + 집중률 문장
    private var timeAndScoreText: some View {
      VStack(alignment: .leading, spacing: 15) {
        HStack {
          Text("\(taskData.startTime.formatted(date: .omitted, time: .shortened)) ~ \(taskData.endTime.formatted(date: .omitted, time: .shortened))")
            .font(.FontSystem.b1)
            .foregroundColor(Color.B_00)
          Spacer()
        }

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
    }

    // MARK: - 프로그레스 바
    private var progressBar: some View {
      ZStack {
        Capsule()
          .fill(Color.BR_50)
          .frame(height: 8)

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
    }

    // MARK: - 집중시간, 공부시간
    private var focusAndTotalTime: some View {
      HStack(spacing: 40) {
        TimeIndicatorBox(
          title: "집중시간",
          color: .BR_00,
          timeString: AnalyzeView.formatSeconds(Double(taskData.focusTime))
        )

        TimeIndicatorBox(
          title: "공부시간",
          color: .BR_50,
          timeString: AnalyzeView.formatSeconds(Double(taskData.durationTime))
        )
      }
    }
  }
}

private extension AnalyzeView {
  // MARK: - 공통 시간 인디케이터 박스
  struct TimeIndicatorBox: View {
    let title: String
    let color: Color
    let timeString: String

    var body: some View {
      VStack(alignment: .leading) {
        HStack(spacing: 5) {
          Rectangle()
            .fill(color)
            .frame(width: 12, height: 12)
            .cornerRadius(1.3)
          Text(title)
            .font(.FontSystem.b1)
            .foregroundColor(Color.B_20)
        }
        Text(timeString)
          .font(.FontSystem.h4)
          .fontWeight(.bold)
          .foregroundColor(color == .BR_00 ? color : Color.B_20)
      }
    }
  }
}

#Preview {
  let container = try! ModelContainer(
    for: TaskData.self,
    configurations: ModelConfiguration(isStoredInMemoryOnly: true)
  )

  let context = container.mainContext
  context.insert(TaskData.mock)

  return AnalyzeView.FocusTimeOverviewView(taskData: TaskData.mock)
}

