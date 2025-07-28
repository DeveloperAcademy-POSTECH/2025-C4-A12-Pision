//
//  HistoryRowView.swift
//  Pision
//
//  Created by YONGWON SEO on 7/21/25.
//

import SwiftUI

// MARK: - Var
struct HistoryRowView: View {
  @Binding var isNext: Bool
  
  let task:TaskData
  var avgFocus: Int {
    guard task.durationTime > 0 else { return 0 }
    return Int((Double(task.focusTime) / Double(task.durationTime)) * 100)
  }
}

// MARK: - View
extension HistoryRowView {
  var body: some View {
    HStack{
      VStack(alignment: .leading){
        HStack{
          Text("\(formatted(task.startTime))")
            .font(.FontSystem.b1)
            .foregroundStyle(.black)
          Text("~")
          Text("\(formatted(task.endTime))")
            .font(.FontSystem.b1)
            .foregroundStyle(.black)
          Spacer()
          Image(systemName: "chevron.right")
        }
        //Spacer()
        Text("")
        HStack(alignment:.bottom){
          Text(secondsToHourMinute(task.focusTime))
            .font(.FontSystem.h1)
            .foregroundStyle(.BR_00)
          Text(secondsToHourMinute(task.durationTime))
            .font(.FontSystem.b1)
            .foregroundStyle(.B_40)
          Spacer()
          Text("\(avgFocus)%")
            .font(.FontSystem.h2)
            .foregroundStyle(.black)
        }
        CustomProgressBar(value: Double(avgFocus)/100.0)
        HStack(){
          RoundedRectangle(cornerRadius: 2)
            .frame(width: 10, height: 10)
            .foregroundStyle(.BR_00)
          Text("집중시간")
            .font(.FontSystem.btn)
            .foregroundStyle(.B_40)
          Spacer()
          RoundedRectangle(cornerRadius: 2)
            .frame(width: 10, height: 10)
            .foregroundStyle(.BR_50)
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
    .navigationDestination(
      isPresented: $isNext) {
        AnalyzeView()
      }
  }
}


// MARK: - Func
extension HistoryRowView{
  func formatted(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter.string(from: date)
  }
  
  func secondsToHourMinute(_ seconds: Int) -> String {
    let hours = seconds / 3600
    let minutes = (seconds % 3600) / 60
    return "\(hours)시간 \(minutes)분"
  }
}

#Preview {
  HistoryRowView(isNext: .constant(true), task: HistoryView.mock)
}
