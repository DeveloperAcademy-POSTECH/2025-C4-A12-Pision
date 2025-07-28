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
        Text("사용자의 측정기록을 바탕으로 집중도를 측정하고 있어요!")
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
  }
}

//MARK: Func
extension LoadingView{

}

#Preview {
    LoadingView()
}
