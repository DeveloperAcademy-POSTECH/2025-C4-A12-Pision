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

          CustomLottieView(animation: "Loading")
            .frame(width: 100, height: 50)
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
          coordinator.popToRoot()
        }
      } else {
        progress += 1
      }
    }
  }
}

#Preview {
  LoadingView()
    .environmentObject(Coordinator(/* 필요 파라미터 있으면 채우기 */))
  
}

