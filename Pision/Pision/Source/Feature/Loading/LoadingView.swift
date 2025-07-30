//
//  LoadingView.swift
//  Pision
//
//  Created by YONGWON SEO on 7/28/25.
//

import SwiftUI
import SwiftData

struct LoadingView: View {
  @EnvironmentObject private var coordinator: Coordinator
  @Environment(\.modelContext) private var context
  
  @State private var progress: Int = 0
  @State private var timer: Timer?
  @State private var showAlternateMessage: Bool = false
}

// MARK: - View
extension LoadingView {
  var body: some View {
    GeometryReader { geo in
      ZStack {
        Image("background")
          .resizable()
          .ignoresSafeArea()

        CustomLottieView(animation: "loading_character")
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .ignoresSafeArea()

        VStack(spacing: 20) {
          Spacer()
          Text("\(progress)%")
            .font(.FontSystem.h0)
            .foregroundStyle(.BR_00)
            .padding(.horizontal)

          // Loading 애니메이션이 없는 경우 대체
          Group {
            if Bundle.main.path(forResource: "Loading", ofType: "json") != nil {
              CustomLottieView(animation: "Loading")
                .frame(width: 100, height: 50)
            } else {
              ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .BR_00))
                .scaleEffect(1.5)
                .frame(height: 50)
            }
          }
          .padding(.bottom, geo.size.height * 0.10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
      }
    }
    .navigationBarBackButtonHidden()
    .onAppear {
      startProgress()
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        showAlternateMessage = true
      }
    }
    .onDisappear {
      timer?.invalidate()
      timer = nil
    }
  }
}

// MARK: - Func
extension LoadingView {
  private func startProgress() {
    let totalTicks = 100
    let duration = 4.5
    let interval = duration / Double(totalTicks)
    
    progress = 0
    timer?.invalidate()
    
    timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { t in
      if progress >= 100 {
        t.invalidate()
        DispatchQueue.main.async {
          // 최신 TaskData 가져와서 AnalyzeView로 이동
          fetchLatestTaskDataAndNavigate()
        }
      } else {
        progress += 1
      }
    }
  }
  
  private func fetchLatestTaskDataAndNavigate() {
    let fetchDescriptor = FetchDescriptor<TaskData>()
    
    do {
      let results = try context.fetch(fetchDescriptor)
      if let latestTask = results.sorted(by: { $0.startTime > $1.startTime }).first {
        // 최신 TaskData로 AnalyzeView 이동
        coordinator.push(.analyze(latestTask, true))
      } else {
        // TaskData가 없으면 홈으로
        coordinator.popToRoot()
      }
    } catch {
      print("❌ TaskData 조회 실패: \(error)")
      coordinator.popToRoot()
    }
  }
}

#Preview {
  LoadingView()
    .environmentObject(Coordinator())
}
