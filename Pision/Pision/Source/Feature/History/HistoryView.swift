//
//  HistoryView.swift
//  Pision
//
//  Created by YONGWON SEO on 7/21/25.
//

import SwiftUI

// MARK: - Var
struct HistoryView: View {
  
}

// MARK: - View
extension HistoryView {
  var body: some View {
    ZStack{
      Image("background")
        .resizable()
        .ignoresSafeArea()
      VStack{
        HStack{
          HStack{
            Text("닉네임")
              .font(.FontSystem.b2)
              .foregroundStyle(.B_20)
            Spacer()
            Text("기록")
              .font(.FontSystem.h4)
              .foregroundStyle(.B_00)
            Spacer()
            Image(systemName: "trophy")
              .foregroundStyle(.BR_00)
            Image(systemName: "gearshape")
              .foregroundStyle(.BR_00)
          }.padding(10)
        }
        .padding(.top)
        .padding(.leading)
        .padding(.trailing)
        ScrollView{
          VStack{
            CalendarView()
            FixedOverListView()
          }
          VStack {
            HStack{
              Text("오늘 측정 리스트")
                .font(.FontSystem.h2)
                .foregroundStyle(.B_20)
                .padding(.leading)
                .padding(.top)
              Spacer()
            }
            ForEach(0..<20) { _ in
              HistoryRowView()
            }
          }
        }
      }
    }
  }
}

// MARK: - Func
extension HistoryView {
  
}

#Preview {
  HistoryView()
}
