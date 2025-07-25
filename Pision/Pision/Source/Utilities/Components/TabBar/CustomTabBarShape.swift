//
//  CustomTabBarShape.swift
//  Pision
//
//  Created by 여성일 on 7/25/25.
//

import SwiftUI

struct CustomTabBarShape: Shape {
  func path(in rect: CGRect) -> Path {
    let width = rect.width
    let height = rect.height
    
    // 중앙과 반지름 설정
    let centerX = width / 2
    let buttonRadius: CGFloat = 35
    let sideRadius: CGFloat = 28
    
    // 좌우 곡선의 수직 중심선과 y좌표
    let curveY: CGFloat = 0
    let sideCenterY = curveY + sideRadius
    let buttonCenterY = curveY + buttonRadius
    
    var path = Path()
    path.move(to: CGPoint(x: 0, y: curveY))
    
    // 왼쪽 직선
    path.addLine(to: CGPoint(x: centerX - buttonRadius - sideRadius, y: curveY))
    
    // 왼쪽 90도 아크 (↘)
    path.addArc(
      center: CGPoint(x: centerX - buttonRadius - 30, y: sideCenterY),
      radius: sideRadius,
      startAngle: .degrees(180),
      endAngle: .degrees(70),
      clockwise: false
    )
    
    // 중앙 반원 (◯)
    path.addArc(
      center: CGPoint(x: centerX, y: buttonCenterY - 20),
      radius: buttonRadius + 4,
      startAngle: .degrees(160),
      endAngle: .degrees(20),
      clockwise: true
    )
    
    // 오른쪽 90도 아크 (↗)
    path.addArc(
      center: CGPoint(x: centerX + buttonRadius + 30, y: sideCenterY),
      radius: sideRadius,
      startAngle: .degrees(160),
      endAngle: .degrees(270),
      clockwise: false
    )
    
    // 오른쪽 직선
    path.addLine(to: CGPoint(x: width, y: 0))
    
    // 화면 오른쪽 아래 끝
    path.addLine(to: CGPoint(x: width, y: height))
    // 화면 왼쪽 아래 끝
    path.addLine(to: CGPoint(x: 0, y: height))
    // 화면 왼쪽 아래 끝이랑 시작점 연결해줌
    path.closeSubpath()
    
    return path
  }
}
