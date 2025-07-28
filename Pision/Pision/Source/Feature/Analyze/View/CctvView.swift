//
//  CctvView.swift
//  Pision
//
//  Created by rundo on 7/27/25.
//

import SwiftUI
import SwiftData

struct CctvView: View {
  @StateObject var viewModel: CctvViewModel
  @State private var showInfoSheet = false
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Button(action: {
        viewModel.toggleExpanded()
      }) {
        contentView
      }
      .buttonStyle(PlainButtonStyle())
      .sheet(isPresented: $showInfoSheet) {
        InfoSheetView(isPresented: $showInfoSheet, data: .cctv, isCctv: true)
      }
    }
  }
  
  private var contentView: some View {
    VStack(alignment: .leading) {
      headerView
      if viewModel.isExpanded {
        CctvImageView
      }
    }
    .padding(20)
    .background(Color.W_00)
    .cornerRadius(16)
    .animation(nil, value: viewModel.isExpanded)  // 애니메이션 비활성화
  }
  
  private var headerView: some View {
    HStack {
      VStack(alignment: .leading, spacing: 4) {
        HStack(spacing: 8) {
          Text("순간포착")
            .font(.FontSystem.h4)
            .foregroundColor(Color.B_00)
          
          Button(action: {
            showInfoSheet = true
          }) {
            Image("info")
          }
        }
        Text("집중력을 잃은 찰나의 순간을 포착해요")
          .font(.FontSystem.btn)
          .foregroundColor(Color.B_20)
      }
      
      Spacer()
      
      Image(viewModel.isExpanded ? "dropUp" : "dropDown")
    }
  }
  
  private var CctvImageView: some View {
    VStack {
      if viewModel.hasSnoozeImages {
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 9) {
            ForEach(Array(viewModel.snoozeImages.enumerated()), id: \.offset) { index, uiImage in
              Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 200)
                .cornerRadius(12)
            }
          }
        }
        FadeOutOverlay()
      } else {
        Text("포착된 순간이 없습니다")
          .foregroundColor(.B_30)
          .padding()
      }
    }
  }
}
