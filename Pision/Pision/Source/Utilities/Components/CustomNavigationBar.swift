//
//  CustomNavigation.swift
//  Pision
//
//  Created by 여성일 on 7/24/25.
//

import SwiftUI
import UIKit

struct CustomNavigationBar: View {
  let title: String
  let showBackButton: Bool
  //let rightButtonContent: RightContent?
  //let rightButtonAction: (() -> Void)?
  
  @Environment(\.dismiss) private var dismiss
  
  init(
    title: String,
    showBackButton: Bool = true,
//     
  ) {
    self.title = title
    self.showBackButton = showBackButton
//    self.rightButtonContent = rightButtonContent
//    self.rightButtonAction = rightButtonAction
  }
  
  var body: some View {
    ZStack {
      // 타이틀
      Text(title)
        .font(.FontSystem.h2)
        .foregroundColor(.B_00)
        .frame(maxWidth: .infinity, alignment: .center)
      
      // 왼쪽 버튼
      HStack {
        if showBackButton {
          Button(action: { dismiss() }) {
            Image(systemName: "chevron.left")
              .font(.title2)
              .foregroundColor(.B_00)
              .frame(width: 24, height: 24)
          }
        } else {
          Spacer().frame(width: 24)
        }
        Spacer()
      }
      
      // 오른쪽 버튼
//      HStack {
//        Spacer()
//        if let content = rightButtonContent,
//           let action = rightButtonAction {
//          Button(action: action) {
//            content
//              .foregroundColor(.B_00)
//              .frame(height: 24)
//          }
//        } else {
//          Spacer().frame(width: 24)
//        }
//      }
    }
    .padding(.horizontal)
    .padding(.bottom, 8)
  }
}

/// 뒤로가기 스와이프
extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
  open override func viewDidLoad() {
    super.viewDidLoad()
    interactivePopGestureRecognizer?.delegate = self
  }
  
  public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    return viewControllers.count > 1
  }
}
