import SwiftUI
import Charts
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
    VStack(alignment: .leading, spacing: 8) {
      ScrollView(.horizontal) {
        Chart {
          ForEach(viewModel.entries) { entry in
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
