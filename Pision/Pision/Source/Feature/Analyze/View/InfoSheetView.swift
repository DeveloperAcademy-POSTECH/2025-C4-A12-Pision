//
//  CoreScoreInfoSheetView.swift
//  Pision
//
//  Created by YONGWON SEO on 7/28/25.
//

import SwiftUI

struct CoreScoreInfoSheetView: View {
  @Binding var isPresented: Bool
  
  var body: some View {
    VStack(spacing: 0) {
      // 상단 헤더
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
            Image(systemName: "chart.bar.doc.horizontal")
              .foregroundColor(.white)
              .font(.system(size: 40))
            
            VStack(alignment: .leading, spacing: 4) {
              Text("CoreScore란?")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
              
              Text("CoreScore는 30초 동안 사용자의 다양한\n지표를 종합적으로 계산해 집중 상태를\n과학적으로 판단해요!")
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
      
      // 하단 설명 부분
      VStack(alignment: .leading, spacing: 20) {
        Text("상세 설명")
          .font(.system(size: 20, weight: .bold))
          .foregroundColor(.black)
          .padding(.horizontal, 20)
          .padding(.top, 24)
        
        Text("연구 논문을 기반으로 적용된 상세 기준을 설명드릴게요")
          .font(.system(size: 14))
          .foregroundColor(.gray)
          .padding(.horizontal, 20)
        
        VStack(alignment: .leading, spacing: 20) {
          infoItem(
            number: "1.",
            title: "머리 Yaw 안정도",
            citation: "(Lee et al., 2019)",
            description: "평균적으로 고개가 45° 이상 돌아가 있다면,\n자주 움직이며 집중 저하로 인지해요."
          )
          
          infoItem(
            number: "2.",
            title: "EAR 눈 크기 평균",
            citation: "(Soukupová & Čech, 2016)",
            description: "눈의 크기 비율값(EAR)이 낮아질수록,\n졸고 있을 확률이 높아요."
          )
          
          infoItem(
            number: "3.",
            title: "눈 감은 비율",
            citation: "(Dinges & Grace, 1998)",
            description: "측정 시간 중, 눈을 감는 프레임 비율이 높으면,\n집중 저하로 인지해요."
          )
          
          infoItem(
            number: "4.",
            title: "눈 깜빡임 빈도",
            citation: "(Benedetto et al., 2011)",
            description: "연구에서는 평균 10~20회/분로 눈을 깜빡이며 집중상태,\n기준 보다 적거나 많으면 집중 저하로 인지해요"
          )
        }
        .padding(.horizontal, 20)
        
        Spacer()
      }
      .background(Color.white)
    }
    .background(Color.white)
  }
  
  private func infoItem(number: String, title: String, citation: String, description: String) -> some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack(spacing: 8) {
        Text(number)
          .font(.system(size: 16, weight: .bold))
          .foregroundColor(.black)
        
        Text(title)
          .font(.system(size: 16, weight: .bold))
          .foregroundColor(.black)
        
        Text(citation)
          .font(.system(size: 14))
          .foregroundColor(.gray)
        
        Spacer()
      }
      
      // 설명 텍스트에서 특정 부분만 파란색으로 강조
      Text(attributedDescription(description))
        .font(.system(size: 14))
        .padding(.leading, 16)
    }
  }
  
  private func attributedDescription(_ text: String) -> AttributedString {
    var attributedString = AttributedString(text)
    
    // 특정 키워드들을 파란색으로 강조
    let blueKeywords = ["45° 이상 돌아가", "자주 움직이며", "졸고 있을 확률", "눈을 감는 프레임 비율", "평균 10~20회/분", "집중 저하로"]
    
    for keyword in blueKeywords {
      if let range = attributedString.range(of: keyword) {
        attributedString[range].foregroundColor = .blue
        attributedString[range].font = .system(size: 14, weight: .medium)
      }
    }
    
    return attributedString
  }
}

#Preview {
  CoreScoreInfoSheetView(isPresented: .constant(true))
}//
//  InfoSheetView.swift
//  Pision
//
//  Created by rundo on 7/28/25.
//

