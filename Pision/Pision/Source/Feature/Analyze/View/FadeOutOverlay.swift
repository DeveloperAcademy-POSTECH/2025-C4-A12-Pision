//
//  FadeOutOverlay.swift
//  Pision
//
//  Created by rundo on 7/28/25.
//

import SwiftUI

// MARK: - 페이드아웃 오버레이 컴포넌트
struct FadeOutOverlay: View {
  var body: some View {
    HStack(spacing: 0) {
      Spacer()
      
      LinearGradient(
        gradient: Gradient(stops: [
          .init(color: Color.W_00.opacity(0), location: 0),
          .init(color: Color.W_00.opacity(0.3), location: 0.3),
          .init(color: Color.W_00.opacity(0.7), location: 0.7),
          .init(color: Color.W_00, location: 1.0)
        ]),
        startPoint: .leading,
        endPoint: .trailing
      )
      .frame(width: 40)
    }
    .allowsHitTesting(false)
  }
}
