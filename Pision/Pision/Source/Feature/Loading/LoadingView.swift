//
//  LoadingView.swift
//  Pision
//
//  Created by YONGWON SEO on 7/28/25.
//

import SwiftUI

struct LoadingView: View {
  @State private var progress = 0
  @State private var messageIndex = 0
  
  
  private let messages: [String] = [
    "사용자의 측정기록을 바탕으로 집중도를 측정하고 있어요!",
    "조금만 기다려 주세요",
  ]

  private let delays: [Double] = [1, 1, 1]

}

//MARK: View
extension LoadingView{
  var body: some View {
    ZStack {
      Image("background")
        .resizable()
        .ignoresSafeArea()
      
      VStack(spacing: 20) {
        
        VStack {
          Text(messages[messageIndex])
            .font(.FontSystem.b2)
            .foregroundStyle(.BR_20)
            .padding(.horizontal, 20)
            .padding(.vertical, 30)
        }
        .background(Color.white)
        .cornerRadius(20)
        .frame(maxWidth: 400)
        
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
  }
}

//MARK: Func
extension LoadingView{

}

#Preview {
    LoadingView()
}
