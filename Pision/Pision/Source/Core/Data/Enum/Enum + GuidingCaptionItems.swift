//
//  Enum + GuidingCaptionItems.swift
//  Pision
//
//  Created by 여성일 on 7/24/25.
//

enum GuidingCaptionItems: Int, CaseIterable {
  case cameraSetting = 1
  case angleSetting = 2
  
  var number: String {
    String(self.rawValue)
  }
  
  var title: String {
    switch self {
    case .cameraSetting:
      return "카메라 세팅"
    case .angleSetting:
      return "각도 설정"
    }
  }
  
  var caption: String {
    switch self {
    case .cameraSetting:
      return "얼굴과 어깨가 화면 안에 들어오도록 배치 해주세요."
    case .angleSetting:
      return "눈이 화면에 잘 보이도록 정면을 바라봐 주세요.\n인식되지 않으면 측정이 어려울 수 있어요."
    }
  }
}
