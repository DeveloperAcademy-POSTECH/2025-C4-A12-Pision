//
//  CustomProgressBar.swift
//  Pision
//
//  Created by YONGWON SEO on 7/26/25.
//

import SwiftUI

struct CustomProgressBar: View {
  var value: Double

  var body: some View {
    GeometryReader { geo in
      ZStack(alignment: .leading) {
        Capsule()
          .foregroundStyle(.BR_50)
        Capsule()
          .foregroundStyle(.BR_00)
          .frame(width: geo.size.width * value)
      }
    }
    .frame(height: 8)
    .frame(maxWidth: .infinity)
  }
}

#Preview {
  CustomProgressBar(value:0.70)
}
