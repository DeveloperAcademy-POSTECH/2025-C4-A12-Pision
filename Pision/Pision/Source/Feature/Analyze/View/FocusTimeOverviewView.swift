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
      VStack(alignment: .leading, spacing: 0) {
        timeAndScoreText
          .padding(.bottom, 25)
        progressBarWithOverlay
          .padding(.bottom, 15)
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
            Text(getFocusMessage(for: Int(taskData.averageScore)).0)
              .font(.FontSystem.h2) +
            Text(getFocusMessage(for: Int(taskData.averageScore)).1)
              .font(.spoqaHanSansNeo(type: .regular, size: 20))
          )
          .foregroundColor(Color.B_10)
        }
      }
    }
    
    // MARK: - 집중률 메시지 함수
    private func getFocusMessage(for score: Int) -> (String, String) {
      switch score {
      case 0...9:
        return ("금붕어보다 못한 집중력", "이네요.")
      case 10...19:
        return ("코끼리의 집중력과 유사", "합니다.")
      case 20...29:
        return ("산만", "하네요.")
      case 30...39:
        return ("개선", "해야 합니다.")
      case 40...49:
        return ("초등학생과 비슷", "합니다.")
      case 50...59:
        return ("평범한 직장인 수준", "입니다.")
      case 60...69:
        return ("대학생다운 집중력", "입니다.")
      case 70...79:
        return ("수험생 못지않은 집중력", "입니다.")
      case 80...89:
        return ("독서광 수준의 집중력", "입니다.")
      case 90...100:
        return ("수도승 같은 집중력", "입니다.")
      default:
        return ("측정 불가", "입니다.")
      }
    }

    // MARK: - 프로그레스 바 + 퍼센트 오버레이
    private var progressBarWithOverlay: some View {
      ZStack {
        // 프로그레스 바
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
        
        // 퍼센트 오버레이 (프로그레스바 끝에 위치)
        GeometryReader { geometry in
          ZStack(alignment: .top) {
            // 말풍선 이미지
            Image(.bubble)
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 50, height: 37)

            // 텍스트 오버레이
            VStack {
              Text("\(Int(taskData.averageScore))%")
                .font(.FontSystem.h4)
                .foregroundColor(.white)
            }.padding(.top,5)
          }
          .position(
            x: geometry.size.width * CGFloat(taskData.averageScore / 100) - 1,
            y: -22 // 프로그레스 바 위로 이동
          )
        }
      }
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
