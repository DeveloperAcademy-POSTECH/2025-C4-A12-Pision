//
//  GuidingCaptionView.swift
//  Pision
//
//  Created by 여성일 on 7/24/25.
//

import SwiftUI

// MARK: - Var
struct GuidingCaptionView: View {
  let item: GuidingCaptionItems
  
  init(
    item: GuidingCaptionItems
  ) {
    self.item = item
  }
}

// MARK: - View
extension GuidingCaptionView {
  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      HStack(spacing: 12) {
        Text(item.number)
          .font(.FontSystem.cap1)
          .foregroundStyle(.B_10)
          .frame(width: 32, height: 32)
          .background(.su00)
          .clipShape(.capsule)
        
        Text(item.title)
          .font(.FontSystem.h4)
          .foregroundStyle(.B_10)
        
        Spacer()
      }
      .padding(.leading, 25)
      
      Text(item.caption)
        .font(.FontSystem.cap2)
        .foregroundStyle(.B_10)
        .padding(.leading, 68)
    }
  }
}

//#Preview {
//  GuidingCaptionView()
//}
