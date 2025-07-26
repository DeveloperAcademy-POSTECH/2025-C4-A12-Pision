//
//  HourlyFocusChartView.swift
//  Pision
//
//  Created by rundo on 7/25/25.
//

import SwiftUI
import SwiftData

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

          HStack(spacing: 5) {
            yAxisLabels
            focusChartWithLabels
          }

          focusChartLegend
        }
        .padding(20)
        .background(Color.W_00)
        .cornerRadius(16)
      }
//      .frame(height: 227)
      .padding(.top, 13)
    }

    /// y축 라벨 (100, 0)
    private var yAxisLabels: some View {
      VStack {
        Text("100")
          .font(.spoqaHanSansNeo(type: .regular, size: 12))
        Spacer()
        Text("0")
          .font(.spoqaHanSansNeo(type: .regular, size: 12))
      }
      .foregroundColor(Color.B_00)
      .padding(.bottom, 5)
    }

    /// 바 차트와 x축 라벨 포함
    private var focusChartWithLabels: some View {
      let dataCount = taskData.focusRatio.count
      let shouldScroll = dataCount > 12
      let chartWidth = CGFloat(max(280, (dataCount + 1) * 20)) // 최소 너비 보장
      
      let chartContent = VStack(alignment: .leading, spacing: 2) {
        chartWithGrid
        xAxisLabels
      }
      .padding(.top, 13)
      .frame(width: chartWidth, height: 115, alignment: .leading)

      return Group {
        if shouldScroll {
          ScrollView(.horizontal, showsIndicators: false) {
            chartContent
          }
        } else {
          chartContent
        }
      }
    }

    /// 차트와 배경 그리드
    private var chartWithGrid: some View {
      ZStack(alignment: .leading) {
        gridLines
        chartBars
      }
//      .frame(minWidth: 350)
    }

    /// 수평 그리드 라인들
    private var gridLines: some View {
      VStack {
        ForEach(0..<5) { _ in
          Rectangle()
            .fill(Color.BR_50)
            .frame(height: 1)
          Spacer()
        }
        Rectangle()
          .fill(Color.BR_50)
          .frame(height: 1)
      }
    }

    /// 포커스 데이터에 따른 바 그래프
    private var chartBars: some View {
      HStack(spacing: 7.1) {
        ForEach(Array(taskData.focusRatio.enumerated()), id: \.offset) { idx, ratio in
          ZStack {
            Rectangle()
              .fill(Color.BR_50)
              .frame(width: 15.38, height: 95)
              .cornerRadius(4)

            VStack {
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
      .padding(.leading, 7.1)
    }

    /// x축 시간 레이블 (30분 단위)
    private var xAxisLabels: some View {
      HStack(spacing: 16) {
        Text("10분")
          .font(.spoqaHanSansNeo(type: .regular, size: 12))
        HStack(spacing: 32.3) {
          ForEach(Array(taskData.focusRatio.enumerated()), id: \.offset) { idx, _ in
            if idx >= 2 && (idx + 1) * 10 % 30 == 0 {
              Text("\((idx + 1) * 10)분")
                .font(.spoqaHanSansNeo(type: .regular, size: 12))
                .frame(width: 35, height: 12)
            }
          }
        }
      }
      .padding(.leading, 2)
    }

    /// 범례 표시
    private var focusChartLegend: some View {
      HStack {
        Spacer()
        legendItem(color: .BR_20, label: "집중시간")
        Spacer().frame(width: 50)
        legendItem(color: .BR_50, label: "공부시간")
        Spacer()
      }
    }

    /// 범례 아이템 컴포넌트
    private func legendItem(color: Color, label: String) -> some View {
      HStack(spacing: 5) {
        Rectangle()
          .fill(color)
          .frame(width: 10, height: 10)
          .cornerRadius(1.3)
        Text(label)
          .font(.FontSystem.btn).bold()
          .foregroundColor(Color.B_20)
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

  return VStack(spacing: 8) {
    AnalyzeView.HourlyFocusChartView(taskData: TaskData.mock)
  }
  .padding(.horizontal, 20)
  .padding(.top, 5)
  .frame(height: 300)
  .modelContainer(container)
  .background(Color.BR_00)
}
