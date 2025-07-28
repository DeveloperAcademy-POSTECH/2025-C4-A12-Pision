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
  
  var body: some View {
    VStack(spacing: 0) {
      // 상단 헤더
      headerSection
      
      // 하단 설명 부분
      contentSection
    }
    .background(Color.white)
  }
  
  private var headerSection: some View {
    ZStack {
      Color.blue // 파란색 배경
      
      VStack(spacing: 16) {
        HStack {
          Spacer()
          Button(action: {
            isPresented = false
          }) {
            Image(systemName: "xmark")
              .foregroundColor(.white)
              .font(.system(size: 18, weight: .medium))
          }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        
        // 아이콘과 제목
        HStack(spacing: 12) {
          Image(systemName: data.iconName)
            .foregroundColor(.white)
            .font(.system(size: 40))
          
          VStack(alignment: .leading, spacing: 4) {
            Text(data.title)
              .font(.system(size: 24, weight: .bold))
              .foregroundColor(.white)
            
            Text(data.description)
              .font(.system(size: 14))
              .foregroundColor(.white)
              .multilineTextAlignment(.leading)
          }
          
          Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
      }
    }
    .frame(height: 200)
  }
  
  private var contentSection: some View {
    VStack(alignment: .leading, spacing: 20) {
      Text("상세 설명")
        .font(.system(size: 20, weight: .bold))
        .foregroundColor(.black)
        .padding(.horizontal, 20)
        .padding(.top, 24)
      
      Text("여러 논문을 기반으로 적용된 상세 기준을 설명드릴게요")
        .font(.system(size: 14))
        .foregroundColor(.gray)
        .padding(.horizontal, 20)
      
      ScrollView {
        VStack(alignment: .leading, spacing: 20) {
          ForEach(Array(data.items.enumerated()), id: \.offset) { index, item in
            infoItemView(item: item)
          }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 50)
      }
    }
    .background(Color.white)
  }
  
  private func infoItemView(item: InfoItem) -> some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack(spacing: 8) {
        Text(item.number)
          .font(.system(size: 16, weight: .bold))
          .foregroundColor(.black)
        
        Text(item.title)
          .font(.system(size: 16, weight: .bold))
          .foregroundColor(.black)
        
        if let citation = item.citation {
          Text(citation)
            .font(.system(size: 14))
            .foregroundColor(.gray)
        }
        
        Spacer()
      }
      
      Text(attributedDescription(item.description, keywords: item.highlightedKeywords))
        .font(.system(size: 14))
        .padding(.leading, 16)
    }
  }
  
  private func attributedDescription(_ text: String, keywords: [String]) -> AttributedString {
    var attributedString = AttributedString(text)
    
    // 키워드들을 파란색으로 강조
    for keyword in keywords {
      if let range = attributedString.range(of: keyword) {
        attributedString[range].foregroundColor = .blue
        attributedString[range].font = .system(size: 14, weight: .medium)
      }
    }
    
    return attributedString
  }
}

#Preview {
  InfoSheetView(isPresented: .constant(true), data: .coreScore)
}

//#Preview {
//  InfoSheetView(isPresented: .constant(true), data: .auxScore)
//}
