//
//  CoreInfoData.swift
//  Pision
//
//  Created by rundo on 7/28/25.
//

// MARK: - CoreScore 데이터
extension InfoSheetData {
  static let coreScore = InfoSheetData(
    title: "CoreScore란?",
    description: "CoreScore는 30초 동안 사용자의 다양한\n지표를 종합적으로 계산해 집중 상태를\n과학적으로 판단해요!",
    iconName: "chart.bar.doc.horizontal",
    items: [
      InfoItem(
        number: "1.",
        title: "머리 Yaw 안정도",
        citation: "(Lee et al., 2019)",
        description: "평균적으로 고개가 45° 이상 돌아가 있거나,\n자주 움직이면 집중 저하로 인지해요.",
        highlightedKeywords: ["45° 이상 돌아가", "자주 움직이면"]
      ),
      InfoItem(
        number: "2.",
        title: "EAR 눈 크기 평균",
        citation: "(Soukupová & Čech, 2016)",
        description: "눈의 크기 비율값(EAR)이 낮아질수록,\n졸고 있을 확률이 높아요.",
        highlightedKeywords: ["눈의 크기 비율값, 졸고 있을 확률"]
      ),
      InfoItem(
        number: "3.",
        title: "눈 감은 비율",
        citation: "(Dinges & Grace, 1998)",
        description: "측정 시간 중, 눈을 감는 프레임 비율이 높으면,\n집중 저하로 인지해요.",
        highlightedKeywords: ["눈을 감는 프레임 비율", "집중 저하로"]
      ),
      InfoItem(
        number: "4.",
        title: "눈 깜빡임 빈도",
        citation: "(Benedetto et al., 2011)",
        description: "연구에서는 평균 10~20회/분로 눈을 깜빡이면 집중상태,\n기준 보다 적거나 많으면 집중 저하로 인지해요.",
        highlightedKeywords: ["평균 10~20회/분", "눈을 깜빡", "집중 저하로"]
      )
    ]
  )
}
