//
//  HistoryRowView.swift
//  Pision
//
//  Created by YONGWON SEO on 7/21/25.
//

import SwiftUI

// MARK: - Var
struct HistoryRowView: View {

}

// MARK: - View
extension HistoryRowView {
  var body: some View {
    HStack{
        VStack(alignment: .leading){
          HStack{
            Text("12:00 ~ 16:27 am")
              .font(.FontSystem.b1)
              .foregroundStyle(.black)
            Spacer()
            Image(systemName: "chevron.right")
              .foregroundStyle(.gray)
          }
          //Spacer()
          Text("")
          HStack{
            Text("3시간 20분")
              .font(.FontSystem.h1)
              .foregroundStyle(.BR_00)
            Text("4시간 47분")
              .font(.FontSystem.b1)
              .foregroundStyle(.B_40)
            Spacer()
            Text("90.6%")
              .font(.FontSystem.h2)
              .foregroundStyle(.black)
          }
          CustomProgressBar(value: 0.75)
          HStack{
            RoundedRectangle(cornerRadius: 2)
              .frame(width: 10, height: 10)
              .foregroundStyle(.BR_00)
            Text("집중시간")
              .font(.FontSystem.btn)
              .foregroundStyle(.B_40)
            Spacer()
            RoundedRectangle(cornerRadius: 2)
              .frame(width: 10, height: 10)
              .foregroundStyle(.gray)
            Text("전체시간")
              .font(.FontSystem.btn)
              .foregroundStyle(.B_40)
          }
        }
    }
    .buttonStyle(PlainButtonStyle())
    .frame(maxWidth:.infinity, maxHeight: .infinity, alignment:.leading)
    .padding()
    .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
    .padding(.horizontal)
  }
}

struct CustomProgressBar: View {
    var value: Double // 0.0 ~ 1.0
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                .foregroundStyle(.gray)
                    .frame(height: 10) // <- 원하는 두께
                Capsule()
                .foregroundStyle(.BR_00)
                    .frame(width: geo.size.width * value, height: 10) // <- 원하는 두께
            }
        }
    }
}

// MARK: - Func
extension HistoryRowView{
  
  
  
}

#Preview {
    HistoryRowView()
}
