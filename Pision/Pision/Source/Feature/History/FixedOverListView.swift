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
    VStack{
      
      
      
      Picker("기간 선택", selection: $selectedIndex){
        ForEach(options, id:\.self){ option in
          Text((option))
        }
      }
      .pickerStyle(.segmented)
      .frame(maxHeight:.infinity)
      .padding()
      
      VStack{
        Text("집중시간")
        Text("6H 40")
      }
      .padding()
      .frame(maxHeight:.infinity)
      
      VStack{

        HStack{
          VStack{
            Text("횟수")
            Text("3")
          }
          .frame(maxWidth:.infinity)
          VStack{
            Text("총 공부시간")
            Text("9H 32")
          }
          .frame(maxWidth:.infinity)
          VStack{
            Text("평균 집중도")
            Text("97%")
          }
          .frame(maxWidth:.infinity)
        }
        .frame(maxHeight:.infinity)
      }
      .padding()

    }
    .background(RoundedRectangle(cornerRadius: 12).fill(Color.blue.opacity(0.1)))
    .padding(12)
  }
}

// MARK: - Func
extension FixedOverListView {
  

  
}


#Preview {
    FixedOverListView()
}
