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
      return "손을 들어 화면에"
    case .stopPose:
      return "손을 들고 1초간"
    }
  }
  
  var regularCaption: String {
    switch self {
    case .startPose:
      " 비춰주세요."
    case .stopPose:
      " 유지해주세요."
    }
  }
}
