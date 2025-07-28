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

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Button(action: {
        viewModel.toggleExpanded()
      }) {
        contentView
      }
      .buttonStyle(PlainButtonStyle())
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
  }

  private var headerView: some View {
    HStack {
      VStack(alignment: .leading, spacing: 4) {
        HStack(spacing: 8) {
          Text("순간포착")
            .font(.FontSystem.h4)
            .foregroundColor(Color.B_00)
          Image("info")
        }
        Text("집중력을 잃은 찰나의 순간을 포착해요")
          .font(.FontSystem.btn)
          .foregroundColor(Color.B_20)
      }

      Spacer()

      HStack(spacing: 16) {
        Text("\(String(format: "%.0f", viewModel.taskData.averageScore))점")
          .font(.spoqaHanSansNeo(type: .bold, size: 28))
          .foregroundColor(Color.BR_00)

        Image(viewModel.isExpanded ? "dropUp" : "dropDown")
      }
    }
  }

  private var CctvImageView: some View {
    VStack {
      if viewModel.hasSnoozeImages {
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 8) {
            ForEach(Array(viewModel.snoozeImages.enumerated()), id: \.offset) { index, uiImage in
              Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 120)
            }
          }
          .padding(.horizontal, 8)
        }
      } else {
        Text("포착된 순간이 없습니다")
          .foregroundColor(.gray)
          .padding()
      }
    }
  }
}
