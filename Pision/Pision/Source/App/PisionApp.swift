//
//  PisionApp.swift
//  Pision
//
//  Created by 여성일 on 7/14/25.
//

import SwiftData
import SwiftUI

@main
struct PisionApp: App {
  @StateObject private var coordinator = Coordinator()
  
  var modelContainer: ModelContainer = {
    let schema = Schema([
      TaskData.self,
      AvgCoreScore.self,
      AvgAuxScore.self
    ])
    
    let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
    
    do {
      return try ModelContainer(for: schema, configurations: [configuration])
    } catch {
      fatalError("ModelContainer err")
    }
  }()
  
  var body: some Scene {
    WindowGroup {
//      NavigationStack {
//        MainView()
//      }
      RootView()
        .environmentObject(coordinator)
    }
    .modelContainer(modelContainer)
  }
}
