//
//  GuidingPoseCaptionView.swift
//  Pision
//
//  Created by 여성일 on 7/24/25.
//

import SwiftUI

struct GuidingPoseCaptionView: View {
  let item: GuidingPoseCaptionItems
  
  init(
    item: GuidingPoseCaptionItems
  ) {
    self.item = item
  }
  
  var body: some View {
    VStack {
      Image(item.image)
    }
    
    HStack(spacing: 0) {
      Text(item.boldCaption)
        .font(.spoqaHanSansNeo(type: .bold, size: 13))
      Text(item.regularCaption)
        .font(.spoqaHanSansNeo(type: .regular, size: 13))
    }
  }
}

