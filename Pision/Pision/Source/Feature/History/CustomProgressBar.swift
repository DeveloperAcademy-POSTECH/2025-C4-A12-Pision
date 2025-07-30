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
      ZStack {
        Capsule()
          .fill(Color.BR_50)
          .frame(height: 8)

        GeometryReader { geometry in
          Capsule()
            .fill(Color.BR_00)
            .frame(
              width: geometry.size.width * CGFloat(value / 100),
              height: 8
            )
        }
      }
      .frame(height: 10)
    }
    .frame(height: 8)
    .frame(maxWidth: .infinity)
  }
}

#Preview {
  CustomProgressBar(value:0.70)
}
