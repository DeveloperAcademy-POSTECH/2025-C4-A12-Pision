//
//  MeasureGuideView.swift
//  Pision
//
//  Created by 여성일 on 7/24/25.
//

import SwiftUI

// MARK: - Var
struct MeasureGuideView: View {
  // viewModel
  @ObservedObject private var viewModel: MeasureViewModel
  
  // init
  init(viewModel: MeasureViewModel) {
    self.viewModel = viewModel
  }
}

// MARK: - View
extension MeasureGuideView {
  var body: some View {
    VStack(spacing: 0) {
      CustomNavigationbar(title: "자세 맞추기", titleColor: .W_00, buttonColor: .W_00)
        .background(Color.B_00.opacity(0.6))
      
      ZStack {
        Color.B_00.opacity(0.6).ignoresSafeArea()
        if !viewModel.showCountdown {
          if viewModel.isPresentedStartModal {
            MeasureStartModalView(viewModel: viewModel)
              .frame(width: 353, height: 485)
              .animation(.easeInOut, value: viewModel.isPresentedStartModal)
          } else {
            guideContentView
              .padding(.bottom, 100)
          }
        }
      }
    }
    .navigationBarBackButtonHidden()
    .overlay(
      ZStack {
        if viewModel.showCountdown {
          CountdownView {
            viewModel.countDownFinish()
          }
        }
      }
    )
    .onAppear {
      viewModel.guidingStart(screenWidth: UIScreen.main.bounds.width)
    }
    .onChange(of: viewModel.isGuidingAngle) {
      viewModel.checkGuidingStatus()
    }
    .onChange(of: viewModel.isGuidingPose) {
      viewModel.checkGuidingStatus()
    }
  }
  
  private var guideContentView: some View {
    VStack(spacing: 32) {
      Spacer()
      
      Text(viewModel.guideCaptionString)
        .font(.FontSystem.h4)
        .foregroundStyle(.W_00)
        .multilineTextAlignment(.center)
      
      HStack(spacing: 46) {
        VStack {
          Image(viewModel.isGuidingAngle ? .guideTrue : .guideFalse)
            .resizable()
            .frame(width: 60, height: 60)
          
          Text("얼굴 맞추기")
            .font(.FontSystem.h3)
          Text("얼굴 각도")
            .font(.FontSystem.cap1)
        }
        .foregroundStyle(viewModel.isGuidingAngle ? .su00 : .W_00)
        
        VStack {
          Image(viewModel.isGuidingPose ? .guideTrue : .guideFalse)
            .resizable()
            .frame(width: 60, height: 60)
          
          Text("자세 맞추기")
            .font(.FontSystem.h3)
          Text("자세 측정")
            .font(.FontSystem.cap1)
        }
        .foregroundStyle(viewModel.isGuidingPose ? .su00 : .W_00)
      }
    }
  }
}

#Preview {
  MeasureGuideView(viewModel: MeasureViewModel())
}
