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
  @EnvironmentObject private var coordinator: Coordinator
  let taskData:TaskData
  var isFromMeasure:Bool = false
  
  init(
    taskData: TaskData,
    isFromMeasure: Bool
  ) {
    self.taskData = taskData
    self.isFromMeasure = isFromMeasure
  }
}

extension AnalyzeView {
  var body: some View {
    ZStack {
      Image(.background)
        .resizable()
        .ignoresSafeArea()
      
      VStack {
        CustomNavigationbar(title: "집중 분석", backButtonAction: { coordinator.popToRoot() })
        
        ScrollView {
          AnalyzeBodyView(taskData: taskData, isFromMeasure: isFromMeasure)
        }
      }
    }
    .navigationBarBackButtonHidden()
  }
}

extension AnalyzeView {
  struct AnalyzeBodyView: View {
    @EnvironmentObject private var coordinator: Coordinator
    let taskData: TaskData
    var isFromMeasure: Bool = false
    
    var body: some View {
      VStack(spacing: 8) {
        FocusTimeOverviewView(taskData: taskData)
        HourlyFocusChartView(taskData: taskData)
        CoreScoreView(viewModel:CoreScoreViewModel(taskData: taskData))
        AuxScoreView(viewModel:AuxScoreViewModel(taskData: taskData))
        CctvView(viewModel: CctvViewModel(taskData: taskData))
        
        if isFromMeasure {
          Button {
            coordinator.popToRoot()
          } label: {
            Text("완 료")
              .font(.FontSystem.h3)
              .foregroundStyle(.W_10)
              .frame(maxWidth: .infinity)
              .frame(height: 48)
              .padding(.horizontal, 20)
              .background(.BR_00)
              .clipShape(RoundedRectangle(cornerRadius: 16))
          }
          .padding(.top, 30)
        }
      }
      .padding(.horizontal, 20)
      .padding(.top, 5)
      .padding(.bottom, 30)
    }
  }
}

// MARK: - 시간 포맷팅 함수
extension AnalyzeView {
  static func formatSeconds(_ time: TimeInterval) -> String {
    let minutes = Int(time) / 60
    let hours = minutes / 60
    let remainingMinutes = minutes % 60
    return "\(hours)시간 \(remainingMinutes)분"
  }
}

