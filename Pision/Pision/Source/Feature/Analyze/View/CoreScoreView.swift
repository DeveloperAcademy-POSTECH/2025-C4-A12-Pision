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
    .frame(height: 230)
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

  /// 라인 차트와 x축 라벨 포함
  private var coreScoreChartWithLabels: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      VStack(alignment: .leading, spacing: 2) {
        chartWithGrid
        xAxisLabels
      }
      .padding(.top, 13)
    }
    .frame(height: 115)
  }

  /// 차트와 배경 그리드
  private var chartWithGrid: some View {
    ZStack(alignment: .leading) {
      gridLines
      lineChart
    }
  }

  // 수평 및 수직 그리드 라인들
    private var gridLines: some View {
      let chartWidth = CGFloat(max(viewModel.dataPointCount * 30, 300))
      let chartHeight: CGFloat = 95
      
      return ZStack {
        // 수평 그리드 라인
        VStack {
          ForEach(0..<5) { _ in
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
          ForEach(0..<viewModel.dataPointCount, id: \.self) { index in
            Rectangle()
              .fill(Color.BR_50.opacity(0.3))
              .frame(width: 1, height: chartHeight)
            if index < viewModel.dataPointCount - 1 {
              Spacer()
            }
          }
        }
        .frame(width: chartWidth, height: chartHeight)
      }
    }

  /// 커스텀 라인 차트
  private var lineChart: some View {
    let chartWidth = CGFloat(max(viewModel.dataPointCount * 30, 300))
    let chartHeight: CGFloat = 95
    
    return ZStack {
      // 고개 자세 라인 (파란색)
      createLineShape(
        points: viewModel.normalizedYawScores,
        color: Color.blue,
        width: chartWidth,
        height: chartHeight
      )
      
      // EAR 비율 라인 (검은색)
      createLineShape(
        points: viewModel.normalizedEyeOpenScores,
        color: Color.black,
        width: chartWidth,
        height: chartHeight
      )
      
      // 눈 EAR 라인 (분홍색)
      createLineShape(
        points: viewModel.normalizedEyeClosedScores,
        color: Color.pink,
        width: chartWidth,
        height: chartHeight
      )
      
      // 깜빡임 빈도 라인 (초록색)
      createLineShape(
        points: viewModel.normalizedBlinkFrequencies,
        color: Color.green,
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
        .stroke(color, lineWidth: 2)
      }
      
      // 포인트 그리기
      ForEach(Array(points.enumerated()), id: \.offset) { index, point in
        let stepX = width / CGFloat(max(points.count - 1, 1))
        let x = CGFloat(index) * stepX
        let y = height - CGFloat(point / 100.0) * height
        
        Circle()
          .fill(color)
          .frame(width: 6, height: 6)
          .position(x: x, y: y)
      }
    }
  }

  /// x축 시간 레이블 (10분, 30분, 60분...)
  private var xAxisLabels: some View {
    HStack(spacing: 16) {
      Text("10분")
        .font(.spoqaHanSansNeo(type: .regular, size: 12))
        .foregroundColor(Color.B_00)
      HStack(spacing: 32.3) {
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
    .padding(.leading, 2)
  }

  /// 범례 표시
  private var coreScoreChartLegend: some View {
    VStack {
      HStack(spacing: 20) {
        legendItem(color: .blue, label: "고개 자세")
        legendItem(color: .black, label: "EAR 비율")
      }
      HStack(spacing: 20) {
        legendItem(color: .pink, label: "눈 EAR")
        legendItem(color: .green, label: "깜빡임 빈도")
      }
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

#Preview {
  let container = try! ModelContainer(
    for: TaskData.self,
    configurations: ModelConfiguration(isStoredInMemoryOnly: true)
  )

  let context = container.mainContext
  context.insert(TaskData.mock)

  return CoreScoreView(viewModel: CoreScoreViewModel(taskData: TaskData.mock))
    .modelContainer(container)
    .padding()
    .background(Color.gray.opacity(0.1))
}
