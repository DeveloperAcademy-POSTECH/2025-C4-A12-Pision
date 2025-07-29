//
//  GuidingCameraView.swift
//  Pision
//
//  Created by 여성일 on 7/24/25.
//

import SwiftUI

// MARK: - Var
struct GuidingCameraView: View {
  @EnvironmentObject private var coordinator: Coordinator
}

// MARK: - View
extension GuidingCameraView {
  var body: some View {
    ZStack {
      Image(.background)
        .resizable()
        .ignoresSafeArea()
      
      VStack {
        CustomNavigationbar(title: "측정 가이드", backButtonAction: { coordinator.pop() })
        GuideCameraContentView
      }
    }
    .navigationBarBackButtonHidden()
  }
  
  private var GuideCameraContentView: some View {
    VStack {
      Text("카메라 측정 기준 가이드")
        .font(.FontSystem.h2)
        .foregroundStyle(.B_10)
        .padding(.bottom, 32)
      
      Image(.guideP101)
        .resizable()
        .frame(width: 124, height: 124)
        .padding(.bottom, 34)
      
      VStack(spacing: 29) {
        ForEach(GuidingCaptionItems.allCases, id: \.self) {
          GuidingCaptionView(item: $0)
        }
      }
      .padding(.bottom, 32)
      
      HStack(spacing: 32) {
        Image(.guideP1Sub01)
          .resizable()
          .frame(width: 50, height: 50)
        
        Image(.guideP1Sub02)
          .resizable()
          .frame(width: 50, height: 50)
        
        Image(.guideP1Sub03)
          .resizable()
          .frame(width: 50, height: 50)
      }
      Spacer()
      
      GuidingButtonView(
        title: "다 음",
        action: { coordinator.push(.guidingPose) }
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
  GuidingCameraView()
}
