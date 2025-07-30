//
//  Enum + MeasureFinishModalItems.swift
//  Pision
//
//  Created by 여성일 on 7/28/25.
//

enum MeasureFinishModalItems {
  case shortTime  // 1분 미만
  case longEnough // 1분 이상
  
  var title: String {
    switch self {
    case .shortTime:
      return "측정 시간이 짧아요"
    case .longEnough:
      return "측정을 종료할까요?"
    }
  }
  
  var caption: String {
    switch self {
    case .shortTime:
      return "1분 이상 측정해야 결과를 확인할 수 있어요.\n그래도 종료할까요?"
    case .longEnough:
      return "지금까지의 측정 결과를\n확인하실 수 있어요."
    }
  }
}
