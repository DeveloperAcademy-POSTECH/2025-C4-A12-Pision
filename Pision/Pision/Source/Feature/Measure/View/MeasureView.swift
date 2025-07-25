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
  @Environment(\.modelContext) private var context
  @StateObject private var viewModel: MeasureViewModel
  
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
      
      if viewModel.isNext {
        MeasureRecordView(viewModel: viewModel, context: context)
      } else { 
        MeasureGuideView(viewModel: viewModel)
      }
    }
    .onAppear {
      viewModel.cameraStart()
    }
    .onDisappear {
      viewModel.cameraStop()
    }
  }
}

#Preview {
  MeasureView()
}


