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
      
      brightnessOverlay
      
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
    .onAppear {
      viewModel.cameraStart()
      viewModel.timerStart()
    }
    .onDisappear {
      viewModel.cameraStop()
    }
    .onTapGesture {
      viewModel.resetAutoDim()
    }
  }
  
  private var brightnessOverlay: some View {
    Rectangle()
      .background(.B_00)
      .opacity(viewModel.isShouldDimScreen ? 0.85 : 0)
      .animation(.easeInOut(duration: 0.3), value: viewModel.isShouldDimScreen)
      .ignoresSafeArea()
  }
}

#Preview {
  MeasureView()
}


