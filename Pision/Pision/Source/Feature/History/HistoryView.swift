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
    VStack{
      HStack{
        HStack{
          Text("이미지")
          Text("닉네임")
          Spacer()
          Image(systemName: "gearshape")
        }.padding(12)
      }
      VStack{
        FixedOverListView()
      }
      VStack {
        ScrollView {
          HistoryRowView()
          HistoryRowView()
          HistoryRowView()
          HistoryRowView()
          HistoryRowView()
          HistoryRowView()
          HistoryRowView()
          HistoryRowView()
          HistoryRowView()
          HistoryRowView()
          HistoryRowView()
        }.frame(maxHeight: .infinity)
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
