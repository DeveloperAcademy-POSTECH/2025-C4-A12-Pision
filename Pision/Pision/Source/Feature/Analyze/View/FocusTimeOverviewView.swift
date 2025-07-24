//
//  FocusTimeOverviewView.swift
//  Pision
//
//  Created by rundo on 7/25/25.
//

import SwiftUI

extension AnalyzeView {
  // MARK: - 집중 개요 뷰
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

        // 집중시간 + 공부시간
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
