//
//  CctvViewModel.swift
//  Pision
//
//  Created by rundo on 7/28/25.
//

import Foundation
import SwiftUI

@MainActor
class CctvViewModel: ObservableObject {
  @Published var isExpanded: Bool = false
  
  let taskData: TaskData
  
  init(taskData: TaskData) {
    self.taskData = taskData
  }
  
  /// 스누즈 이미지들을 UIImage로 변환
  var snoozeImages: [UIImage] {
    return taskData.snoozeImageDatas.compactMap { data in
      UIImage(data: data)
    }
  }
  
  /// 스누즈 이미지가 있는지 확인
  var hasSnoozeImages: Bool {
    return !taskData.snoozeImageDatas.isEmpty
  }
  
  /// 스누즈 이미지 개수
  var snoozeImageCount: Int {
    return taskData.snoozeImageDatas.count
  }
  
  func toggleExpanded() {
    withAnimation(.easeInOut(duration: 0.3)) {
      isExpanded.toggle()
    }
  }
}
