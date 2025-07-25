//
//  CustomNavigationbar.swift
//  Pision
//
//  Created by 여성일 on 7/25/25.
//

import SwiftUI
import UIKit

struct CustomNavigationbar: View {
  let title: String
  let titleColor: Color
  let showBackButton: Bool
  let buttonColor: Color
  
  //let rightButtonContent: RightContent?
  //let rightButtonAction: (() -> Void)?
  
  @Environment(\.dismiss) private var dismiss
  
  init(
    title: String,
    showBackButton: Bool = true,
    titleColor: Color = .B_00,
    buttonColor: Color = .B_00
    //
  ) {
    self.title = title
    self.showBackButton = showBackButton
    self.titleColor = titleColor
    self.buttonColor = buttonColor
    //    self.rightButtonContent = rightButtonContent
    //    self.rightButtonAction = rightButtonAction
  }
}

extension CustomNavigationbar {
  var body: some View {
    ZStack {
      Text(title)
        .font(.FontSystem.h2)
        .foregroundColor(titleColor)
        .frame(maxWidth: .infinity, alignment: .center)
      
      HStack {
        if showBackButton {
          Button(action: { dismiss() }) {
            Image(systemName: "chevron.left")
              .font(.title2)
              .foregroundColor(buttonColor)
              .frame(width: 24, height: 24)
          }
        } else {
          Spacer().frame(width: 24)
        }
        Spacer()
      }
      
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
