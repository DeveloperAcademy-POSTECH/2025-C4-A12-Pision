//
//  HourlyFocusChartView.swift
//  Pision
//
//  Created by rundo on 7/25/25.
//
import SwiftUI

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
