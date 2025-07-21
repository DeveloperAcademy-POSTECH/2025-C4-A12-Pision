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
        Text("2025.03.05")
        Text("6h 40")
        Text("7h 22")
      }
      .frame(maxWidth:.infinity, maxHeight: .infinity, alignment:.leading)
      Spacer()
      Text("도형")
    }
    .padding()
    .background(RoundedRectangle(cornerRadius: 12).fill(Color.blue.opacity(0.2)))
    .padding(.vertical, 4)
    .padding(.horizontal, 12)
  }
}

// MARK: - Func
extension HistoryRowView{
  
}

#Preview {
    HistoryRowView()
}
