//
//  RecordView.swift
//  Pision
//
//  Created by 여성일 on 7/14/25.
//

import AVFoundation
import CoreML
import SwiftData
import SwiftUI

// MARK: - Var
struct MeasureView: View {
  // ViewModel
  @StateObject private var viewModel: MeasureViewModel
  
  // SwiftData
  @Environment(\.modelContext) private var context
  
  // General Var
  @State private var isSheetPresented: Bool = false
  @State private var isBottomButtonPresented: Bool = true
  
  // init
  init() {
    _viewModel = StateObject(wrappedValue: MeasureViewModel())
  }
}

// MARK: - View
extension MeasureView {
  var body: some View {
    ZStack(alignment: .top) {
      Color.clear.ignoresSafeArea()
      
      CameraView(session: viewModel.session)
        .ignoresSafeArea()
      
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
        
        VStack {
          Button {
            viewModel.timerStart()
            updateBottomButtonVisibility()
          } label: {
            Image(systemName: "play.fill")
              .foregroundStyle(.white)
              .frame(width: 70, height: 70)
              .background(.blue)
              .clipShape(.circle)
          }
          .buttonStyle(.plain)
          
          MeasureSheetView(
            viewModel: viewModel,
            context: context
          )
          .frame(maxWidth: .infinity, maxHeight: 196)
        }
      }
    }
    .navigationBarBackButtonHidden()
    .onAppear {
      viewModel.cameraStart()
      viewModel.debugPrintAllSavedData(context: context)
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
}

// MARK: - Func
extension MeasureView {
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


