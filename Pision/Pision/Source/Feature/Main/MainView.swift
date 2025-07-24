//
//  MainView.swift
//  Pision
//
//  Created by 여성일 on 7/14/25.
//

import SwiftUI

struct MainView: View {
}

extension MainView {
  var body: some View {
    ZStack(alignment: .topLeading) {
      Color.clear.ignoresSafeArea()
      VStack {
        Text("당신의 집중을 분석해 보세요")
          .font(.title)
        
        Spacer()
        
        VStack {
          NavigationLink {
            MeasureView()
          } label: {
            Text("시작")
              .foregroundStyle(.white)
              .frame(width: 150, height: 150)
              .background(.black)
              .clipShape(.circle)
          }
          bottomButtonView
        }
        Spacer()
      }
    }.padding(.horizontal, 16)
  }
  
  private var bottomButtonView: some View {
    HStack {
      NavigationLink {
        AnalyzeView()
      } label: {
        Text("기록")
          .foregroundStyle(.white)
          .frame(width: 100, height: 100)
          .background(.black)
          .clipShape(.circle)
      }
      
      Spacer()
      
      Button {
      } label: {
        Text("설정")
          .foregroundStyle(.white)
          .frame(width: 100, height: 100)
          .background(.black)
          .clipShape(.circle)
      }
      .buttonStyle(.plain)
    }
  }
}

#Preview {
  NavigationStack {
    MainView()
  }
}
