//
//  MainTabView.swift
//  Pision
//
//  Created by YONGWON SEO on 7/21/25.
//

import SwiftUI

struct CustomTabBar: View {
  @EnvironmentObject private var coordinator: Coordinator
  
  @Binding var selectedTab: Tab
  
  var body: some View {
    ZStack {
      CustomTabBarShape()
        .fill(Color.white)
        .frame(height: 90)
        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: -2)
      
      HStack {
        tabItem(icon: "tabHome", label: "홈", tab: .home)
        Spacer()
        tabItem(icon: "tabList", label: "기록", tab: .record)
      }
      .padding(.horizontal, 48)
      .padding(.bottom, 16)
      
      Button {
        coordinator.push(.guidingCamera)
      } label: {
        ZStack {
          Circle()
            .foregroundStyle(.BR_00)
            .frame(width: 64, height: 64)
            .shadow(radius: 4)
          VStack(spacing: 0) {
            Image(.tabMeasure)
              .foregroundColor(.white)
              
            Text("측정")
              .font(.FontSystem.btn)
              .foregroundColor(.W_00)
          }
        }
      }
      .offset(y: -32)
    }
  }
  
  func tabItem(icon: String, label: String, tab: Tab) -> some View {
    Button {
      selectedTab = tab
    } label: {
      VStack(spacing: 4) {
        Image(icon)
          .renderingMode(.template)
          .font(.FontSystem.cap1)
          .foregroundColor(selectedTab == tab ? .BR_00 : .B_40)
        
        Text(label)
          .font(.FontSystem.cap1)
          .foregroundColor(selectedTab == tab ? .BR_00 : .B_40)
      }
    }.buttonStyle(.plain)
  }
}

