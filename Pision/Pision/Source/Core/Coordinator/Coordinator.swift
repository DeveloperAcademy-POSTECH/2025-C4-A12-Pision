//
//  Coordinator.swift
//  Pision
//
//  Created by 여성일 on 7/29/25.
//

import SwiftUI

final class Coordinator: ObservableObject {
  @Published var path = NavigationPath()
  
  func push(_ route: Route) {
    path.append(route)
  }
  
  func pop() {
    guard !path.isEmpty else { return }
    path.removeLast()
  }
  
  func popToRoot() {
    path = NavigationPath()
  }
}
