//
//  fixedOverListView.swift
//  Pision
//
//  Created by YONGWON SEO on 7/21/25.
//

import SwiftUI

// MARK: - Var
struct FixedOverListView: View {
  let avgFocus: Int
  let focusTime: Int
  let totalDuration: Int
  let sessionCount: Int
}

// MARK: - View
extension FixedOverListView {
  var body: some View {
    VStack(spacing:16){
      VStack(alignment: .leading){
        HStack{
          Text("당신의 평균 집중률")
            .font(.FontSystem.h3)
            .foregroundStyle(.B_20)
          Spacer()
        }.padding(.bottom, 2)
        HStack{
          Text("\(avgFocus)%")
            .font(.FontSystem.h0)
            .foregroundStyle(.BR_00)
          Spacer()
        }
      }.padding()
      HStack{
        VStack{
          Text("집중 횟수")
            .font(.FontSystem.cap1)
            .foregroundStyle(.B_20)
          Text("\(sessionCount)")
            .font(.FontSystem.h2)
            .foregroundStyle(.BR_00)
        }
        .frame(maxWidth:.infinity)
        Divider()
        VStack{
          Text("총 공부시간")
            .font(.FontSystem.cap1)
            .foregroundStyle(.B_20)
          Text(formatTime(seconds: totalDuration))
            .font(.FontSystem.h2)
            .foregroundStyle(.BR_00)
        }
        .frame(maxWidth:.infinity)
        Divider()
        VStack{
          Text("전체 집중시간")
            .font(.FontSystem.cap1)
            .foregroundStyle(.B_20)
          Text(formatTime(seconds: focusTime))
            .font(.FontSystem.h2)
            .foregroundStyle(.BR_00)
        }
        .frame(maxWidth:.infinity)
      }.padding()
    }
    .padding(10)
    .background(
      ZStack{
        RoundedRectangle(cornerRadius: 12).fill(Color.white)
        Image("HistorycardBG")
          .resizable()
          .scaledToFill()
          .clipped()
      }
    )
    .clipShape(RoundedRectangle(cornerRadius: 12)) 
    .padding(.horizontal)
  }
}

// MARK: - Func
extension FixedOverListView {
  func formatTime(seconds: Int) -> String {
    let hours = seconds / 3600
    let minutes = (seconds % 3600) / 60
    return String(format: "%dh %02d", hours, minutes)
  }
}


#Preview {
  FixedOverListView(
    avgFocus: 73,
    focusTime: 2100,
    totalDuration: 3420,   
    sessionCount: 3
  )
}
