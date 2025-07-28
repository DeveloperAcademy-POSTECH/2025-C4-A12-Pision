//
//  AuxInfoData.swift
//  Pision
//
//  Created by rundo on 7/28/25.
//

// MARK: - AuxScore 데이터
extension InfoSheetData {
  static let auxScore = InfoSheetData(
    title: "AuxScore란?",
    description: "AuxScore는 CoreScore의 도움을 주는\n지표로 보다 세부적이고 긴 주기로 계산해\n집중 상태를 과학적으로 판단해요!",
    iconName: "auxInfo",
    items: [
      InfoItem(
        number: "1.",
        title: "눈 깜빡임 수",
        citation: "(Benedetto et al., 2011)",
        description: "주요지표인 눈 깜빡임 빈도에서 개인차와 환경적 요인같은 오차를 줄이기 위해 사용돼요.",
        highlightedKeywords: ["눈 깜빡임 빈도", "개인차", "환경적 요인", "오차"]
      ),
      InfoItem(
        number: "2.",
        title: "고개 흔들림 (Yaw 변화량)",
        citation: "(Mariella Dreissig, 2020)",
        description: "고개가 좌, 우로 빈번하게 움직이거나 각도가 넓으면,\n집중이 흐트러졌다는 신호예요.",
        highlightedKeywords: ["좌, 우로 빈번하게 움직", "각도가 넓으면"]
      ),
      InfoItem(
        number: "3.",
        title: "졸음 지표",
        citation: "(Wang et al., 2020)",
        description: "졸음 상태를 측정해서 집중력이 낮아진 상태를 찾아내고,\n학습된 AI가 '졸음 확률'을 계산해요.",
        highlightedKeywords: ["졸음 상태를 측정", "학습된 AI"]
      )
    ]
  )
}
