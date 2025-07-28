//
//  InfoSheetModel.swift
//  Pision
//
//  Created by rundo on 7/28/25.
//

// MARK: - 데이터 모델
struct InfoSheetData {
  let title: String
  let description: String
  let iconName: String
  let items: [InfoItem]
}

struct InfoItem {
  let number: String
  let title: String
  let citation: String?
  let description: String
  let highlightedKeywords: [String]
}
