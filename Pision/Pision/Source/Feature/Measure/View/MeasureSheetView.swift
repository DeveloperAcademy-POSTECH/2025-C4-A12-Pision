//
//  MeasureSheetView.swift
//  Pision
//
//  Created by 여성일 on 7/20/25.
//

import SwiftData
import SwiftUI

// MARK: - Var
struct MeasureSheetView: View {
  // ViewModel
  @ObservedObject private var viewModel: MeasureViewModel
  
  // SwiftData
  private let context: ModelContext

  // init
  init(
    viewModel: MeasureViewModel,
    context: ModelContext
  ) {
    self.viewModel = viewModel
    self.context = context
  }
}

// MARK: - View
extension MeasureSheetView {
  var body: some View {
    ZStack {
      Color.W_10.opacity(0.9)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .ignoresSafeArea()
      
      VStack(alignment: .center) {
        Text("학습시간")
          .font(.FontSystem.h3)
          .foregroundStyle(.B_10)
        
        infoView
        
        Text("집중도 \(viewModel.currentFocusRatio)%")
          .font(.FontSystem.h4)
          .foregroundStyle(.W_00)
          .frame(width: 129, height: 40)
          .background(.B_20)
          .clipShape(.capsule)
      }
    }
  }
  
  private var infoView: some View {
    HStack(spacing: 32) {
      Button {
        toggleButtonAction()
      } label: {
        Image(toggleButtonImage())
          .resizable()
          .frame(width: 46, height: 46)
          .clipShape(.circle)
      }
      .buttonStyle(.plain)
      
      Text(viewModel.timeString)
        .font(.FontSystem.h1)
        .foregroundStyle(.B_10)
      
      Button {
        viewModel.timerStop(context: context) { result in
          switch result {
          case .success:
            print("성공")
          case .failed:
            print("실패")
          case .skippedLessThan10Minutes:
            print("10분 미만")
          }
        }
      } label: {
        Image(.btStop)
          .resizable()
          .frame(width: 46, height: 46)
          .clipShape(.circle)
      }
      .buttonStyle(.plain)
    }
  }
}

// MARK: - Func
extension MeasureSheetView {
  private func toggleButtonImage() -> String {
    switch viewModel.timerState {
    case .stopped:
      return "btStop"
    case .running:
      return "btPause"
    case .pause:
      return "btPlay"
    }
  }
  
  private func toggleButtonAction() {
    switch viewModel.timerState {
    case .stopped:
      break
    case .running:
      viewModel.timerPause()
    case .pause:
      viewModel.timerResume()
    }
  }
}

//#Preview {
//  MeasureSheetView(viewModel: MeasureViewModel())
//}
