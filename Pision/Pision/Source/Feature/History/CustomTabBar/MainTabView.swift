//
//  MainTabView.swift
//  Pision
//
//  Created by YONGWON SEO on 7/21/25.
//

import SwiftUI

enum Tab {
    case home
    case measure
    case record
}

struct MainTabView: View {
    @State private var selectedTab: Tab = .home
  
  var cameraOff:Bool {
    selectedTab != .measure
  }

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .home:
                    Color.white.overlay(Text("홈").font(.largeTitle))
                case .measure:
                    MeasureView()
                case .record:
                    HistoryView()
                }
            }
          
          if cameraOff {
              CustomTabBar(selectedTab: $selectedTab)
          }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Tab

    var body: some View {
        ZStack {
            // 배경 모양 (곡선)
            CustomTabBarShape()
                .fill(Color.white)
                .frame(height: 90)
                .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: -2)

            // 왼쪽/오른쪽 탭 버튼
            HStack {
                tabItem(icon: "house.fill", label: "홈", tab: .home)
                Spacer()
                tabItem(icon: "doc.text.fill", label: "기록", tab: .record)
            }
            .padding(.horizontal, 48)
            .padding(.bottom, 16)

            // 중앙 버튼
            Button(action: {
                selectedTab = .measure
            }) {
                ZStack {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 64, height: 64)
                        .shadow(radius: 4)
                    Image(systemName: "clock.badge.checkmark")
                        .foregroundColor(.white)
                        .font(.system(size: 28))
                  // 중앙 버튼 텍스트
                  Text("측정 시작")
                    .font(.system(size:7))
                      .foregroundColor(.white)
                      .offset(y: 22)
                }
            }
            .offset(y: -32)

        }
    }

    func tabItem(icon: String, label: String, tab: Tab) -> some View {
        Button {
            selectedTab = tab
        } label: {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(selectedTab == tab ? .blue : .gray)

                Text(label)
                    .font(.caption)
                    .foregroundColor(selectedTab == tab ? .blue : .gray)
            }
        }
    }
}

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

#Preview {
    MainTabView()
}
