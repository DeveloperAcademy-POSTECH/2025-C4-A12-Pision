//
//  AuxScoreView.swift
//  Pision
//
//  Created by rundo on 7/25/25.
//

import SwiftUI
import SwiftData

struct AuxScoreView: View {
  @StateObject var viewModel: AuxScoreViewModel

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
    VStack(alignment: .leading) {
      headerView
      if viewModel.isExpanded {
        chartSectionView
      }
    }
    .padding(20)
    .background(Color.W_00)
    .cornerRadius(16)
    .animation(nil, value: viewModel.isExpanded)  // 애니메이션 비활성화
  }

  private var headerView: some View {
    HStack {
      VStack(alignment: .leading, spacing: 4) {
        HStack(spacing: 8) {
          Text("AuxScore")
            .font(.FontSystem.h4)
            .foregroundColor(Color.B_00)
          Image("info")
        }
        Text("세부적인 정보로 집중도를 파악해요")
          .font(.FontSystem.btn)
          .foregroundColor(Color.B_20)
      }

      Spacer()

      HStack(spacing: 16) {
        Text("\(viewModel.averageScoreText)점")
          .font(.spoqaHanSansNeo(type: .bold, size: 28))
          .foregroundColor(Color.BR_00)

        Image(viewModel.isExpanded ? "dropUp" : "dropDown")
      }
    }
  }

  private var chartSectionView: some View {
    VStack(alignment: .leading, spacing: 20) {
      HStack(spacing: 0) {
        yAxisLabels
        auxScoreChartWithLabels
      }

      auxScoreChartLegend
    }
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
    .padding(.bottom, 10)
    .padding(.top, 5)
    .frame(width: 25)
  }

  /// 라인 차트와 x축 라벨 포함
  private var auxScoreChartWithLabels: some View {
    let dataCount = viewModel.dataPointCount
    let shouldScroll = dataCount > 12
    
    let chartContent = VStack(alignment: .leading, spacing: 2) {
      chartWithGrid
      xAxisLabels
    }
    .padding(.top, 13)

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
    .frame(height: 120) // 차트 높이 고정
    .padding(.leading, 5)
  }

  /// 수평 및 수직 그리드 라인들
  private var gridLines: some View {
    let dataCount = viewModel.dataPointCount
    let chartWidth = CGFloat(max(280, (dataCount + 1) * 20))
    let chartHeight: CGFloat = 120
    
    // 수직 그리드 라인 개수 결정
    let verticalLineCount = max(14, viewModel.dataPointCount + 1)
    let spacing = (chartWidth - CGFloat(verticalLineCount)) / CGFloat(verticalLineCount - 1)
    
    return ZStack {
      // 수평 그리드 라인
      VStack(spacing: 0) {
        ForEach(0..<5) { index in
          Rectangle()
            .fill(Color.BR_50)
            .frame(width: chartWidth, height: 1)
          if index < 4 {
            Spacer()
          }
        }
      }
      .frame(height: chartHeight)
      
      // 수직 그리드 라인 (조건부 개수)
      HStack(spacing: spacing) {
        ForEach(0..<verticalLineCount, id: \.self) { index in
          Rectangle()
            .fill(Color.BR_50)
            .frame(width: 1, height: chartHeight)
        }
      }
      .frame(width: chartWidth, height: chartHeight)
    }
  }

  /// 커스텀 라인 차트
  private var lineChart: some View {
    let chartWidth = CGFloat((viewModel.dataPointCount) * 20)
    let chartHeight: CGFloat = 120
    
    return ZStack {
      // 깜빡임 점수 라인 (파란색)
      createLineShape(
        points: viewModel.normalizedBlinkScores,
        color: Color.BR_00,
        width: chartWidth,
        height: chartHeight
      )
      
      // 고개 안정성 라인 (검은색)
      createLineShape(
        points: viewModel.normalizedYawStabilityScores,
        color: Color.B_00,
        width: chartWidth,
        height: chartHeight
      )
      
      // 졸음 점수 라인 (분홍색)
      createLineShape(
        points: viewModel.normalizedMlSnoozeScores,
        color: Color.su10,
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
          let stepX = 22
          
          for (index, point) in points.enumerated() {
            let x = CGFloat((index) * stepX + 10)
            let y = height - CGFloat(point / 100.0) * height
            
            // 각 포인트별 상세 정보
            print("Point \(index): value=\(point), x=\(x), y=\(y)")
            
            if index == 0 {
              path.move(to: CGPoint(x: x, y: y))
            } else {
              path.addLine(to: CGPoint(x: x, y: y))
            }
          }
          print("========================")
        }
        .stroke(color, lineWidth: 1)
      }
      
      // 최고점에만 포인트 그리기
      if let maxValue = points.max(),
         let maxIndex = points.firstIndex(of: maxValue) {
        let stepX = 22
        let x = CGFloat((maxIndex) * stepX + 10)
        let y = height - CGFloat(maxValue / 100.0) * height
        
        Circle()
          .fill(color)
          .frame(width: 7, height: 7)
          .position(x: x, y: y)
      }
    }
  }

  /// x축 시간 레이블 (10분, 30분, 60분...)
  private var xAxisLabels: some View {
    HStack(spacing: 0) {
      HStack {
        Text("10분")
          .font(.spoqaHanSansNeo(type: .regular, size: 12))
          .foregroundColor(Color.B_00)
        Spacer()
      }
      .frame(width: 35)
      HStack(spacing: 22.5) {
        ForEach(Array(viewModel.normalizedBlinkScores.enumerated()), id: \.offset) { idx, _ in
          if idx >= 2 && (idx + 1) * 10 % 30 == 0 {
            HStack {
              Text("\((idx + 1) * 10)분")
                .font(.spoqaHanSansNeo(type: .regular, size: 12))
                .foregroundColor(Color.B_00)
            }
            .frame(width: 40)
          }
        }
      }
    }
    .padding(.leading, 5)
    .frame(height: 15) // X축 라벨 높이 고정
  }

  /// 범례 표시
  private var auxScoreChartLegend: some View {
    HStack(spacing: 40) {
      Spacer()
      VStack(alignment: .leading, spacing: 6) {
        legendItem(color: .BR_00, label: "깜빡임 점수")
        legendItem(color: .su10, label: "졸음 점수")
      }
      VStack(alignment: .leading, spacing: 0) {
        legendItem(color: .B_00, label: "고개 안정성")
        Spacer()
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

#Preview {
  let container = try! ModelContainer(
    for: TaskData.self,
    configurations: ModelConfiguration(isStoredInMemoryOnly: true)
  )

  let context = container.mainContext
  context.insert(TaskData.mock)

  return AuxScoreView(viewModel: AuxScoreViewModel(taskData: TaskData.mock))
    .modelContainer(container)
    .padding()
    .background(Color.gray.opacity(0.1))
}
