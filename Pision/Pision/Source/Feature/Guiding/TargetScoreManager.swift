//
//  TargetScoreManager.swift
//  Pision
//
//  Created by 여성일 on 7/30/25.
//

import Foundation

/// 전역 목표 집중도 관리자
class TargetScoreManager: ObservableObject {
  static let shared = TargetScoreManager()
  
  @Published private(set) var currentTargetScore: Int = 0
  
  private init() {}
  
  /// 40~100 사이의 짝수 임의 집중도를 생성합니다
  func generateTargetScore() -> Int {
    // 40, 42, 44, ..., 98, 100 중에서 랜덤 선택
    let evenNumbers = Array(stride(from: 40, through: 100, by: 2))
    let randomScore = evenNumbers.randomElement() ?? 80
    
    currentTargetScore = randomScore
    print("🎯 목표 집중도 생성: \(randomScore)%")
    
    return randomScore
  }
  
  /// 현재 목표 점수를 반환합니다
  func getCurrentTargetScore() -> Int {
    return currentTargetScore
  }
  
  /// 목표 점수를 초기화합니다
  func resetTargetScore() {
    currentTargetScore = 0
  }
}
