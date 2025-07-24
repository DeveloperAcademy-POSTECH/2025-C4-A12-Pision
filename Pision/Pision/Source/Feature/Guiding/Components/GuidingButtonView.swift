//
//  GuidingButtonView.swift
//  Pision
//
//  Created by 여성일 on 7/24/25.
//

import SwiftUI

struct GuidingButtonView: View {
  let title: String
  let action: () -> Void
  
  init(title: String, action: @escaping () -> Void) {
    self.title = title
    self.action = action
  }
  
  var body: some View {
    Button {
      action()
    } label: {
      Text(title)
        .font(.FontSystem.h3)
        .foregroundStyle(.W_00)
        .frame(maxWidth: .infinity)
        .frame(height: 48)
        .background(.BR_00)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    .buttonStyle(.plain)
  }
}
