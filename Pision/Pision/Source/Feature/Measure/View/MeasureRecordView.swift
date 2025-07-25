//
//  MeasureRecordView.swift
//  Pision
//
//  Created by 여성일 on 7/24/25.
//

import AVFoundation
import CoreML
import SwiftData
import SwiftUI

// MARK: - Var
struct MeasureRecordView: View {
  // ViewModel
  @ObservedObject private var viewModel: MeasureViewModel
  
  // SwiftData
  private let context: ModelContext
  
  // General Var
  @State private var isSheetPresented: Bool = false
  @State private var isBottomButtonPresented: Bool = true
  @State private var isOverlayPresented: Bool = false
  
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
extension MeasureRecordView {
  var body: some View {
    ZStack(alignment: .top) {
      Color.clear.ignoresSafeArea()
      
      LinearGradient(colors: [Color.gradientGray, Color.white.opacity(0)], startPoint: .top, endPoint: .bottom)
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: 116)
      
      VStack {
        MeasureToggleButtonView(
          viewModel: viewModel,
          buttonWidth: 63,
          height: 38
        )
        
        Spacer()
        
        MeasureSheetView(
          viewModel: viewModel,
          context: context
        )
        .frame(height: 171)
        .padding(.horizontal, 26)
        .padding(.bottom, 24)
      }
    }
    .navigationBarBackButtonHidden()
    .overlay(alignment: .center, content: {
      if isOverlayPresented {
        testOveray
      } else {
        testOveray.hidden()
      }
    })
    .onAppear {
      viewModel.cameraStart()
      viewModel.timerStart()
    }
    .onDisappear {
      viewModel.cameraStop()
    }
    .onReceive(viewModel.$shouldDimScreen) { shouldDim in
      if shouldDim {
        dimScreenGradually(to: 0.01, duration: 0.3)
      } else {
        UIScreen.main.brightness = 1.0
      }
    }
    .onTapGesture {
      guard !viewModel.isAutoBrightnessModeOn else { return }
      UIScreen.main.brightness = 1.0
      viewModel.resetAutoDimTimer()
    }
  }
  
  private var testOveray: some View {
    ZStack {
      Color.B_00.opacity(0.6)
        .ignoresSafeArea()
    }
  }
}

// MARK: - Func
extension MeasureRecordView {
  private func showSheet() {
    isSheetPresented = true
  }
  
  private func updateBottomButtonVisibility() {
    isBottomButtonPresented = false
  }
  
  private func dimScreenGradually(to target: CGFloat, duration: TimeInterval) {
    let current = UIScreen.main.brightness
    let steps = 60
    let interval = duration / Double(steps)
    let delta = (current - target) / CGFloat(steps)
    
    for step in 1...steps {
      DispatchQueue.main.asyncAfter(deadline: .now() + interval * Double(step)) {
        let newBrightness = max(target, current - delta * CGFloat(step))
        UIScreen.main.brightness = newBrightness
      }
    }
  }
}

#Preview {
  MeasureView()
}


