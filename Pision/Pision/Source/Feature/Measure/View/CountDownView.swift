//
//  CountDownView.swift
//  Pision
//
//  Created by 여성일 on 7/25/25.
//

import SwiftUI

// MARK: - Var
struct CountdownView: View {
  @State private var count = 3
  let onFinished: () -> Void
}

// MARK: - View
extension CountdownView {
  var body: some View {
    Text("\(count)")
      .font(.spoqaHanSansNeo(type: .bold, size: 128))
      .foregroundColor(.W_00)
      .onAppear {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
          if count > 1 {
            count -= 1
          } else {
            timer.invalidate()
            onFinished()
          }
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}
