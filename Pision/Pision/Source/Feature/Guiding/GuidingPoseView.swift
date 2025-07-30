//
//  GuidingPoseView.swift
//  Pision
//
//  Created by 여성일 on 7/24/25.
//

import SwiftUI

// MARK: - Var
struct GuidingPoseView: View {
  @EnvironmentObject private var coordinator: Coordinator
  @StateObject private var targetScoreManager = TargetScoreManager.shared
  @State private var showTargetScore = false
  @State private var targetScore = 0
}

// MARK: - View
extension GuidingPoseView {
  var body: some View {
    ZStack {
      Image(.background)
        .resizable()
        .ignoresSafeArea()
      
      VStack {
        CustomNavigationbar(title: "측정 가이드", backButtonAction: { coordinator.pop() })
        GuidePoseContentView
      }
    }
    .navigationBarBackButtonHidden()
    .onAppear {
      generateAndShowTargetScore()
    }
  }
  
  private var GuidePoseContentView: some View {
    VStack {
      Text("시작과 정지 사인")
        .font(.FontSystem.h2)
        .foregroundStyle(.B_10)
        .padding(.bottom, 8)
      
      Text("카메라 세팅이 완료 되었다면,\n손동작으로 간편하게 시작해보세요!")
        .multilineTextAlignment(.center)
        .font(.FontSystem.b1)
        .foregroundStyle(.B_00)
        .padding(.bottom, 20)
      
      // 목표 집중도 표시
      if showTargetScore {
        VStack(spacing: 6) {
          HStack {
            Text("당신의 목표 집중도")
              .font(.system(size: 14, weight: .bold))
              .foregroundStyle(.BR_00)
            
            Text("\(targetScore)%")
              .font(.system(size: 20, weight: .bold))
              .foregroundStyle(.BR_00)
              .padding(.horizontal, 12)
              .padding(.vertical, 6)
              .background(.BR_00.opacity(0.1))
              .clipShape(Capsule())
          }
        }
      }
      
      VStack(spacing: 0) {
        VStack {
          Image(.lefthand)
            .resizable()
            .frame(width: 181, height: 332)
        }
      }
      Spacer()
      
      GuidingButtonView(
        title: "확인했어요",
        action: { coordinator.push(.measure) }
      )
      .padding(.bottom, 32)
      .padding(.horizontal, 21)
    }
    .padding(.top, 55)
    .frame(maxWidth: 353, maxHeight: 671)
    .background(.W_00)
    .clipShape(RoundedRectangle(cornerRadius: 15.27))
  }
}

// MARK: - Private Functions
extension GuidingPoseView {
  private func generateAndShowTargetScore() {
    // 목표 점수 생성 (40~100 사이의 짝수)
    targetScore = targetScoreManager.generateTargetScore()
    
    // 0.5초 후에 애니메이션과 함께 표시
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      showTargetScore = true
    }
  }
}

#Preview {
  GuidingPoseView()
}
