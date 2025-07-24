//
//  GuidingPoseCaptionItems.swift
//  Pision
//
//  Created by 여성일 on 7/24/25.
//

enum GuidingPoseCaptionItems: String, CaseIterable {
  case startPose = "stratPose"
  case stopPose = "stopPose"
  
  var image: String {
    rawValue
  }
  
  var boldCaption: String {
    switch self {
    case .startPose:
      return "손을 펴는 동작"
    case .stopPose:
      return "주먹을 쥐면"
    }
  }
  
  var regularCaption: String {
    switch self {
    case .startPose:
      "으로 바로 측정을 시작할 수 있어요."
    case .stopPose:
      " 언제든 측정을 종료할 수 있어요."
    }
  }
}
