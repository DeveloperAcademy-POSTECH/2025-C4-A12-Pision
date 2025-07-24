//
//  fixedOverListView.swift
//  Pision
//
//  Created by YONGWON SEO on 7/21/25.
//

import SwiftUI

// MARK: - Var
struct FixedOverListView: View {
  @State private var selectedIndex: String = "주"
  let options = ["주", "월", "년", "전체"]
}

// MARK: - View
extension FixedOverListView {
  var body: some View {
    VStack(spacing:16){
      VStack(alignment: .leading){
        HStack{
          Text("당신의 평균 집중률")
            .font(.FontSystem.h3)
            .foregroundStyle(.B_30)
          Spacer()
        }.padding(.bottom, 2)
        HStack{
          Text("73%")
            .font(.FontSystem.h1)
            .foregroundStyle(.BR_00)
          Spacer()
        }
      }.padding()
      HStack{
        VStack{
          Text("집중 횟수")
            .font(.FontSystem.cap1)
            .foregroundStyle(.B_20)
          Text("3")
            .font(.FontSystem.h2)
            .foregroundStyle(.BR_00)
        }
        .frame(maxWidth:.infinity)
        Divider()
        VStack{
          Text("총 공부시간")
            .font(.FontSystem.cap1)
            .foregroundStyle(.B_20)
          Text("9H 32")
            .font(.FontSystem.h2)
            .foregroundStyle(.BR_00)
        }
        .frame(maxWidth:.infinity)
        Divider()
        VStack{
          Text("전체 집중시간")
            .font(.FontSystem.cap1)
            .foregroundStyle(.B_20)
          Text("6h 40")
            .font(.FontSystem.h2)
            .foregroundStyle(.BR_00)
        }
        .frame(maxWidth:.infinity)
      }.padding()
    }
    .padding(10)
    .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
    .padding(.horizontal)
  }
}

// MARK: - Func
extension FixedOverListView {
  
}


#Preview {
  FixedOverListView()
}
