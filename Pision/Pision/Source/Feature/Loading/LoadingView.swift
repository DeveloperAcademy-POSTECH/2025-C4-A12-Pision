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
    ZStack {
      Image("background")
        .resizable()
        .ignoresSafeArea()
      
      VStack(spacing: 20) {
        Text(showAlternateMessage
             ? "조금만 기다려 주세요"
             : "사용자의 측정기록을 바탕으로 집중도를 측정하고 있어요!")
        .font(.spoqaHanSansNeo(type: .bold, size: 16))
        .foregroundStyle(.BR_20)
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
        .frame(height: 102)
        .background(.W_00)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal, 69)
        
        LottieView(animation: "zipzoongi")
          .frame(width: 300, height: 300)
        
        Text("\(progress)%")
          .font(.FontSystem.h3)
          .foregroundStyle(.BR_00)
          .padding(.horizontal)
        
        LottieView(animation: "Loading")
          .frame(width: 100, height: 100)
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
    let duration = 2.5
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

//#Preview {
//  LoadingView()
//}
