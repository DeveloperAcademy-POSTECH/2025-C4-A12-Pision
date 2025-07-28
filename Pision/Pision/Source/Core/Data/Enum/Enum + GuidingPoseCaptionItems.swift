//
//  GuidingPoseCaptionItems.swift
//  Pision
//
//  Created by 여성일 on 7/24/25.
//

enum GuidingPoseCaptionItems: CaseIterable {
  case startPose
  case stopPose
  
  var boldCaption: String {
    switch self {
    case .startPose:
      return "주먹을 쥐는 동작"
    case .stopPose:
      return "위와 같은 동작"
    }
  }
  
  var regularCaption: String {
    switch self {
    case .startPose:
      "으로 바로 측정을 시작할 수 있어요."
    case .stopPose:
      "으로 언제든 측정을 종료할 수 있어요."
    }
  }
}
