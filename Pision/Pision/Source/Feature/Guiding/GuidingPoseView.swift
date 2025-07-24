//
//  GuidingPoseView.swift
//  Pision
//
//  Created by 여성일 on 7/24/25.
//

import SwiftUI

// MARK: - Var
struct GuidingPoseView: View {
  @State private var isNavigate: Bool = false
}

// MARK: - View
extension GuidingPoseView {
  var body: some View {
    ZStack {
      Image(.background)
        .resizable()
        .ignoresSafeArea()
      
      VStack {
        Text("시작과 정지 사인")
          .font(.FontSystem.h2)
          .foregroundStyle(.B_10)
          .padding(.bottom, 15)
        
        Text("카메라 세팅이 완료 되었다면,\n손동작으로 간편하게 시작해보세요!")
          .multilineTextAlignment(.center)
          .font(.FontSystem.b1)
          .foregroundStyle(.B_00)
          .padding(.bottom, 35)
        
        VStack(spacing: 29) {
          ForEach(GuidingPoseCaptionItems.allCases, id: \.self) {
            GuidingPoseCaptionView(item: $0)
          }
        }
        Spacer()
        
        GuidingButtonView(
          title: "확인했어요",
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
      MeasureView()
    }
  }
}

extension GuidingPoseView {
  private func processNavigation() {
    isNavigate = true
  }
}

#Preview {
    GuidingPoseView()
}
