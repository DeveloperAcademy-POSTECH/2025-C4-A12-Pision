//
//  GuidingCameraView.swift
//  Pision
//
//  Created by 여성일 on 7/24/25.
//

import SwiftUI

// MARK: - Var
struct GuidingCameraView: View {
  @State private var isNavigate: Bool = false
}

// MARK: - View
extension GuidingCameraView {
  var body: some View {
    ZStack {
      Image(.background)
        .resizable()
        .ignoresSafeArea()
      
      VStack {
        Text("카메라 측정 기준 가이드")
          .font(.FontSystem.h2)
          .foregroundStyle(.B_10)
        
        VStack(spacing: 29) {
          ForEach(GuidingCaptionItems.allCases, id: \.self) {
            GuidingCaptionView(item: $0)
          }
        }
        Spacer()
        
        GuidingButtonView(
          title: "다 음",
          action: { processNavigation() }
        )
        .padding(.bottom, 32)
        .padding(.horizontal, 21)
      }
      .padding(.top, 55)
      .frame(maxWidth: 353, maxHeight: 671)
      .background(.W_00)
      .clipShape(RoundedRectangle(cornerRadius: 15.27))
    }
    .navigationBarBackButtonHidden()
    .navigationDestination(isPresented: $isNavigate) {
      GuidingPoseView()
    }
  }
}

extension GuidingCameraView {
  private func processNavigation() {
    isNavigate = true
  }
}

#Preview {
  GuidingCameraView()
}
