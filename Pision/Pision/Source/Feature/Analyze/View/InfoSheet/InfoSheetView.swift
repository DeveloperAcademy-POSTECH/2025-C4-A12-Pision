//
//  InfoSheetView.swift
//  Pision
//
//  Created by YONGWON SEO on 7/28/25.
//

import SwiftUI

// MARK: - 재사용 가능한 InfoSheetView
struct InfoSheetView: View {
  @Binding var isPresented: Bool
  let data: InfoSheetData
  let isCctv: Bool
  
  private let cctvDescription: String = "무심코 지나친 '집중 OFF' 순간을 되돌아보면,\n집중 패턴을 파악하고 더 나은 하루를 설계할 수 있어요!"
  
  private let cctvHighlightedKeywords: [String] = ["집중 OFF", "집중 패턴을 파악하고", "더 나은 하루를 설계할 수 있어요"]
  
  var body: some View {
    VStack(spacing: 0) {
      // 상단 헤더
      headerSection
      
      // 하단 설명 부분
      contentSection
    }
    .background(Color.white)
    .presentationDetents([.height(644)]) // 고정 높이
  }
  
  private var headerSection: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack {
        Spacer()
        
        // x 버튼
        Button(action: {
          isPresented = false
        }) {
          Image(systemName: "xmark")
            .resizable()
            .frame(width: 15, height: 15)
            .font(.system(size: 20, weight: .semibold))
            .foregroundColor(.W_00)
        }
      }
//      .padding(.top, 15)
      .padding(.trailing, 18)
      
      // 아이콘과 제목
      HStack(spacing: 38) {
        Image(data.iconName)
          .resizable()
          .frame(width: 79, height: 79)
        
        VStack(alignment: .leading, spacing: 4) {
          Text(data.title)
            .font(.spoqaHanSansNeo(type: .bold, size: 28))
            .foregroundColor(.W_00)
          
          Text(data.description)
            .font(.FontSystem.cap1)
            .foregroundColor(.W_00)
        }
      }
      .padding(.horizontal, 35)
      .padding(.bottom, 20)
//      .background(Color.green).opacity(0.3)

    }
//    .background(Color.green).opacity(0.3)
    .frame(height: 168)
    .background(Color.BR_00)
  }
  
  private var contentSection: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text("상세 설명")
        .font(.spoqaHanSansNeo(type: .bold, size: 20))
        .foregroundColor(.black)
      
      if isCctv == true {
        Text("사용자님의 3가지 상태를 측정해요!")
          .font(.spoqaHanSansNeo(type: .medium, size: 12))
          .foregroundColor(Color.B_20)
      } else {
        Text("여러 논문을 기반으로 적용된 상세 기준을 설명드릴게요")
          .font(.spoqaHanSansNeo(type: .medium, size: 12))
          .foregroundColor(Color.B_20)
      }
      Spacer()
        .frame(height: 1)
      
      Rectangle()
        .frame(height: 1)
        .foregroundColor(Color.B_40)
      
      VStack(alignment: .leading, spacing: 20) {
        ForEach(Array(data.items.enumerated()), id: \.offset) { index, item in
          infoItemView(item: item)
        }
        
        if isCctv == true {
          VStack(alignment: .leading, spacing: 12) {
            Text("왜 필요할까요?")
              .font(.spoqaHanSansNeo(type: .bold, size: 20))
              .foregroundColor(.black)
            
            Rectangle()
              .frame(height: 1)
              .foregroundColor(Color.B_40)

            Text(attributedDescription(cctvDescription, keywords: cctvHighlightedKeywords))
              .font(.FontSystem.b1)
          }
          .padding(.top, 20)
        }
      }
      .padding(.top, 9)
      Spacer()
    }
    .padding(.top, 24)
    .padding(.horizontal, 20)
    .background(Color.W_00)
  }
  
  private func infoItemView(item: InfoItem) -> some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack(spacing: 8) {
        Text(item.number)
          .font(.FontSystem.h4)
          .foregroundColor(.black)
        
        Text(item.title)
          .font(.FontSystem.h4)
          .foregroundColor(.black)
        
        if let citation = item.citation {
          Text(citation)
            .font(.FontSystem.btn)
            .foregroundColor(.B_40)
        }
        
        Spacer()
      }
      
      // 점과 설명 텍스트
      HStack(alignment: .top, spacing: 8) {
        Text("•")
          .font(.FontSystem.b1)
          .foregroundColor(.B_10)
        
        Text(attributedDescription(item.description, keywords: item.highlightedKeywords))
          .font(.FontSystem.b1)
      }
      .padding(.leading, 16)
    }
  }
  
  private func attributedDescription(_ text: String, keywords: [String]) -> AttributedString {
    var attributedString = AttributedString(text)
    
    // 키워드들을 파란색으로 강조
    for keyword in keywords {
      if let range = attributedString.range(of: keyword) {
        attributedString[range].foregroundColor = .BR_00
        attributedString[range].font = .FontSystem.b2
      }
    }
    
    return attributedString
  }
}

//#Preview {
//  InfoSheetView(isPresented: .constant(true), data: .coreScore, isCctv: false)
//}

//#Preview {
//  InfoSheetView(isPresented: .constant(true), data: .auxScore)
//}
