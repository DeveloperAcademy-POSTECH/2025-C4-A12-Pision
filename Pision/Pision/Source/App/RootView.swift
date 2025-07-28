//
//  RootView.swift
//  Pision
//
//  Created by 여성일 on 7/29/25.
//

import SwiftUI

struct RootView: View {
  @EnvironmentObject var coordinator: Coordinator
  @StateObject private var measureViewModel: MeasureViewModel
  
  init() {
    _measureViewModel = StateObject(wrappedValue: MeasureViewModel())
  }
}

extension RootView {
  var body: some View {
    NavigationStack(path: $coordinator.path) {
      MainView()
        .navigationDestination(for: Route.self) { route in
          switch route {
          case .home:
            MainView()
          case .measure:
            MeasureView()
          case .guidingCamera:
            GuidingCameraView()
          case .guidingPose:
            GuidingPoseView()
          case .loading:
            LoadingView()
          case .analyze(let taskData):
            AnalyzeView(taskData: taskData)
          }
        }
    }
  }
}

