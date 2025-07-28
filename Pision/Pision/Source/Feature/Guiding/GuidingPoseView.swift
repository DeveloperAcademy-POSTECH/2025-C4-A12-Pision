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
}

// MARK: - View
extension GuidingPoseView {
  var body: some View {
    ZStack {
      Image(.background)
        .resizable()
        .ignoresSafeArea()
      
      VStack {
        CustomNavigationbar(title: "측정 가이드")
        GuidePoseContentView
      }
    }
    .navigationBarBackButtonHidden()
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
        .padding(.bottom, 42)
      
      VStack(spacing: 29) {
        ForEach(GuidingPoseCaptionItems.allCases, id: \.self) {
          GuidingPoseCaptionView(item: $0)
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

#Preview {
  GuidingPoseView()
}
