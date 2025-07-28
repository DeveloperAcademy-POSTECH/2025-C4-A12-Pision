//
//  MeasureStartModalView.swift
//  Pision
//
//  Created by 여성일 on 7/25/25.
//

import SwiftUI

// MARK: - Var
struct MeasureStartModalView: View {
  @State private var showGestureGuide = false
  
  // ViewModel
  @ObservedObject private var viewModel: MeasureViewModel
  
  // init
  init(
    viewModel: MeasureViewModel
  ) {
    self.viewModel = viewModel
  }
}

// MARK: - View
extension MeasureStartModalView {
  var body: some View {
    ZStack {
      Color.W_00.opacity(0.4)
        .ignoresSafeArea()
      
      VStack(alignment: .center) {
        if !showGestureGuide {
          Text("성일님 집중 측정을 위한\n세팅이 완료 되었어요")
            .padding(.top, 50)
            .font(.FontSystem.h2)
            .foregroundStyle(.W_00)
            .multilineTextAlignment(.center)
        } else {
          Text("측정하기 버튼 또는\n제스처를 취해 시작해 주세요")
            .padding(.top, 50)
            .font(.FontSystem.h2)
            .foregroundStyle(.W_00)
            .multilineTextAlignment(.center)
        }
        
        Spacer()
        
        Image(showGestureGuide ? .guideHandIcon : .guideTrue)
          .resizable()
          .frame(width: showGestureGuide ? 132 : 164, height: showGestureGuide ? 180 : 164)
        
        Spacer()
        
        Button {
          viewModel.guidingFinish()
        } label: {
          Text("측정하기")
            .font(.FontSystem.h3)
            .foregroundStyle(.W_00)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(.B_20.opacity(0.2))
            .clipShape(.capsule)
            .padding(.horizontal, 32)
        }
        .buttonStyle(.plain)
        .padding(.bottom, 49)
      }
    }
    .clipShape(RoundedRectangle(cornerRadius: 16))
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        isShowGestureGuide()
      }
    }
  }
}

// MARK: - Private Func
extension MeasureStartModalView {
  private func isShowGestureGuide() {
    showGestureGuide = true
  }
}
