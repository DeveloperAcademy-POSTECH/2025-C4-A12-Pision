//
//  CoreScoreView.swift
//  Pision
//
//  Created by rundo on 7/25/25.
//

import SwiftUI
import SwiftData

struct CoreScoreView: View {
  @StateObject var viewModel: CoreScoreViewModel

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Button(action: {
        viewModel.toggleExpanded()
      }) {
        contentView
      }
      .buttonStyle(PlainButtonStyle())
    }
  }

  private var contentView: some View {
    VStack {
      headerView
      if viewModel.isExpanded {
        chartSectionView
      }
    }
    .padding(20)
    .background(Color.W_00)
    .cornerRadius(16)
  }

  private var headerView: some View {
    HStack {
      VStack(alignment: .leading, spacing: 4) {
        HStack(spacing: 8) {
          Text("CoreScore")
            .font(.FontSystem.h4)
            .foregroundColor(Color.B_00)
          Image("info")
        }
        Text("실시간 정보로 집중도를 파악해요")
          .font(.FontSystem.btn)
          .foregroundColor(Color.B_20)
      }

      Spacer()

      HStack(spacing: 16) {
        Text("\(viewModel.averageScoreText)%")
          .font(.spoqaHanSansNeo(type: .bold, size: 28))
          .foregroundColor(Color.BR_00)

        Image(viewModel.isExpanded ? "dropUp" : "dropDown")
      }
    }
  }

  private var chartSectionView: some View {
    VStack(alignment: .leading, spacing: 20) {
      HStack(spacing: 5) {
        yAxisLabels
        coreScoreChartWithLabels
      }

      coreScoreChartLegend
    }
    .frame(height: 195)
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
    .padding(.bottom, 3)
  }

  /// 라인 차트와 x축 라벨 포함
  private var coreScoreChartWithLabels: some View {
    let dataCount = viewModel.dataPointCount
    let shouldScroll = dataCount > 12
    let chartWidth = CGFloat(max(280, (dataCount + 1) * 20)) // 최소 너비 보장
    
    let chartContent = VStack(alignment: .leading, spacing: 2) {
      chartWithGrid
      xAxisLabels
    }
    .padding(.top, 13)
    .frame(width: chartWidth, alignment: .leading)

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
      lineChart
    }
    .padding(.leading, 5)
  }

  /// 수평 및 수직 그리드 라인들
  private var gridLines: some View {
    let chartWidth = CGFloat((viewModel.dataPointCount + 1 ) * 20)
    let chartHeight: CGFloat = 120
    
    return ZStack {
      // 수평 그리드 라인
      VStack {
        ForEach(0..<4) { _ in
          Rectangle()
            .fill(Color.BR_50.opacity(0.5))
            .frame(width: chartWidth, height: 1)
          Spacer()
        }
        Rectangle()
          .fill(Color.BR_50.opacity(0.5))
          .frame(width: chartWidth, height: 1)
      }
      .frame(height: chartHeight)
      
      // 수직 그리드 라인
      HStack {
        ForEach(0..<viewModel.dataPointCount + 1, id: \.self) { index in
          Rectangle()
            .fill(Color.BR_50.opacity(0.3))
            .frame(width: 1, height: chartHeight)
          if index < viewModel.dataPointCount {
            Spacer()
          }
        }
      }
      .frame(width: chartWidth, height: chartHeight)
    }
  }

  /// 커스텀 라인 차트
  private var lineChart: some View {
    let chartWidth = CGFloat((viewModel.dataPointCount) * 20)
    let chartHeight: CGFloat = 95
    
    return ZStack {
      // 고개 자세 라인 (파란색)
      createLineShape(
        points: viewModel.normalizedYawScores,
        color: Color.BR_00,
        width: chartWidth,
        height: chartHeight
      )
      
      // EAR 비율 라인 (검은색)
      createLineShape(
        points: viewModel.normalizedEyeOpenScores,
        color: Color.B_00,
        width: chartWidth,
        height: chartHeight
      )
      
      // 눈 EAR 라인 (분홍색)
      createLineShape(
        points: viewModel.normalizedEyeClosedScores,
        color: Color.su10,
        width: chartWidth,
        height: chartHeight
      )
      
      // 깜빡임 빈도 라인 (초록색)
      createLineShape(
        points: viewModel.normalizedBlinkFrequencies,
        color: Color.su00,
        width: chartWidth,
        height: chartHeight
      )
    }
    .frame(width: chartWidth, height: chartHeight)
  }

  /// 라인과 포인트를 그리는 함수
  private func createLineShape(points: [Double], color: Color, width: CGFloat, height: CGFloat) -> some View {
    ZStack {
      // 라인 그리기
      if points.count > 1 {
        Path { path in
          let stepX = width / CGFloat(max(points.count - 1, 1))
          
          for (index, point) in points.enumerated() {
            let x = CGFloat(index) * stepX
            let y = height - CGFloat(point / 100.0) * height
            
            if index == 0 {
              path.move(to: CGPoint(x: x, y: y))
            } else {
              path.addLine(to: CGPoint(x: x, y: y))
            }
          }
        }
        .stroke(color, lineWidth: 1)
      }
      
      // 최고점에만 포인트 그리기
      if let maxValue = points.max(),
         let maxIndex = points.firstIndex(of: maxValue) {
        let stepX = width / CGFloat(max(points.count - 1, 1))
        let x = CGFloat(maxIndex) * stepX
        let y = height - CGFloat(maxValue / 100.0) * height
        
        Circle()
          .fill(color)
          .frame(width: 7, height: 7)
          .position(x: x, y: y)
      }
    }
    .padding(.leading, 10)
  }

  /// x축 시간 레이블 (10분, 30분, 60분...)
  private var xAxisLabels: some View {
    HStack(spacing: 12) {
      Text("10분")
        .font(.spoqaHanSansNeo(type: .regular, size: 12))
        .foregroundColor(Color.B_00)
      HStack(spacing: 27.5) {
        ForEach(Array(viewModel.normalizedYawScores.enumerated()), id: \.offset) { idx, _ in
          if idx >= 2 && (idx + 1) * 10 % 30 == 0 {
            Text("\((idx + 1) * 10)분")
              .font(.spoqaHanSansNeo(type: .regular, size: 12))
              .foregroundColor(Color.B_00)
              .frame(width: 35, height: 12)
          }
        }
      }
    }
    .padding(.leading, 3)
  }

  /// 범례 표시
  private var coreScoreChartLegend: some View {
    HStack(spacing: 40) {
      Spacer()
      VStack(alignment: .leading, spacing: 6) {
        legendItem(color: .BR_00, label: "고개 자세")
        legendItem(color: .su10, label: "눈 EAR")
      }
      VStack(alignment: .leading, spacing: 6) {
        legendItem(color: .B_00, label: "EAR 비율")
        legendItem(color: .su00, label: "깜빡임 빈도")
      }
      Spacer()
    }
  }

  /// 범례 아이템 컴포넌트
  private func legendItem(color: Color, label: String) -> some View {
    HStack(spacing: 5) {
      Rectangle()
        .fill(color)
        .frame(width: 12, height: 12)
        .cornerRadius(1.3)
      Text(label)
        .font(.FontSystem.btn).bold()
        .foregroundColor(Color.B_20)
    }
  }
}

//#Preview {
//  let container = try! ModelContainer(
//    for: TaskData.self,
//    configurations: ModelConfiguration(isStoredInMemoryOnly: true)
//  )
//
//  let context = container.mainContext
//  context.insert(TaskData.mock)
//
//  return CoreScoreView(viewModel: CoreScoreViewModel(taskData: TaskData.mock))
//    .modelContainer(container)
//    .padding()
//    .background(Color.gray.opacity(0.1))
//}
