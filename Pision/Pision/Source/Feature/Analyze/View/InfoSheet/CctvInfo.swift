//
//  CCTVInfoData.swift
//  Pision
//
//  Created by YONGWON SEO on 7/28/25.
//

import Foundation

// MARK: - CCTV(순간 포착) 데이터
extension InfoSheetData {
  static let cctv = InfoSheetData(
    title: "순간 포착이란?",
    description: "사용자님의 집중이 5초 이상 끊기면\n자동으로 얼굴을 캡처해 '집중 OFF'\n순간을 기록해요!",
    iconName: "cctvInfo",
    items: [
      InfoItem(
        number: "1.",
        title: "졸음 상태",
        citation: nil,
        description: "눈은 뜨고 있지만 정신은 멍한 상태",
        highlightedKeywords: ["정신은 멍한"]
      ),
      InfoItem(
        number: "2.",
        title: "딴청 상태",
        citation: nil,
        description: "고개가 좌우로 흔들흔들, 시선이 여기저기",
        highlightedKeywords: ["흔들흔들", "여기저기"]
      ),
      InfoItem(
        number: "3.",
        title: "멍때림 상태",
        citation: nil,
        description: "시선은 고정되어 있지만 생각은 딴 곳에",
        highlightedKeywords: ["딴 곳"]
      )
    ],
  )
}
