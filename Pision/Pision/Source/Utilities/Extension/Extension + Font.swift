//
//  Extension + Font.swift
//  Pision
//
//  Created by 여성일 on 7/24/25.
//

import SwiftUI

extension Font {
  enum SpoqaHanSansNeo {
    case bold
    case medium
    case regular
    
    var value: String {
      switch self {
      case .bold:
        return "SpoqaHanSansNeo-Bold"
      case .medium:
        return "SpoqaHanSansNeo-Medium"
      case .regular:
        return "SpoqaHanSansNeo-regular"
      }
    }
  }
  
  static func spoqaHanSansNeo(type: SpoqaHanSansNeo, size: CGFloat) -> Font {
    return .custom(type.value, size: size)
  }
  
  struct FontSystem {
    static let h0 = Font.spoqaHanSansNeo(type: .bold, size: 38)
    static let h1 = Font.spoqaHanSansNeo(type: .bold, size: 24)
    static let h2 = Font.spoqaHanSansNeo(type: .regular, size: 20)
    static let h3 = Font.spoqaHanSansNeo(type: .bold, size: 18)
    static let h4 = Font.spoqaHanSansNeo(type: .bold, size: 16)
    static let b1 = Font.spoqaHanSansNeo(type: .medium, size: 14)
    static let b2 = Font.spoqaHanSansNeo(type: .bold, size: 14)
    static let btn = Font.spoqaHanSansNeo(type: .medium, size: 12)
    static let cap1 = Font.spoqaHanSansNeo(type: .medium, size: 12)
    static let cap2 = Font.spoqaHanSansNeo(type: .regular, size: 12)
  }
}
