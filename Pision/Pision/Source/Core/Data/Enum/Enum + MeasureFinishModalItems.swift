//
//  Enum + MeasureFinishModalItems.swift
//  Pision
//
//  Created by 여성일 on 7/28/25.
//

enum MeasureFinishModalItems: Identifiable {
  case longEnough
  case tooShort
  
  var id: Int { hashValue }

  var title: String {
    switch self {
    case .longEnough:
      return "측정을 종료하시겠습니까"
    case .tooShort:
      return "앗! 아직 시간이 조금 부족해요"
    }
  }
  
  var caption: String {
    switch self {
    case .longEnough:
      return "종료후에는 이어서 할 수 없어요\n그래도 종료할까요?"
    case .tooShort:
      return "10분 이상 측정해야 결과를 확인할 수 있어요.\n그래도 종료할까요?"
    }
  }
}
