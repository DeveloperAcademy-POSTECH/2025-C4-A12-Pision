//
//  MainView.swift
//  Pision
//
//  Created by 여성일 on 7/14/25.
//

import SwiftUI

// MARK: - Var
struct MainView: View {
  @State private var selectedTab: Tab = .home
  @State private var measurePath = NavigationPath()
}


// MARK: - View
extension MainView {
  var body: some View {
    ZStack(alignment: .bottom) {
      Group {
        switch selectedTab {
        case .home:
          Color.white.overlay(Text("홈").font(.largeTitle))
        case .record:
          HistoryView()
        }
      }
      CustomTabBar(selectedTab: $selectedTab)
    }
    .ignoresSafeArea(edges: .bottom)
  }
}

#Preview {
  NavigationStack {
    MainView()
  }
}
