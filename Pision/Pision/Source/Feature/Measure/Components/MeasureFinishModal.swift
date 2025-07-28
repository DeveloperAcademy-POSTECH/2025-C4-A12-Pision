//
//  MeasureFinishModal.swift
//  Pision
//
//  Created by 여성일 on 7/28/25.
//

import SwiftUI

// MARK: - Var
struct MeasureFinishModal: View {
  let type: MeasureFinishModalItems
  var leftAction: (() -> Void)
  var rightAcition: (() -> Void)
  
  init(
    type: MeasureFinishModalItems,
    leftAction: @escaping () -> Void,
    rightAcition: @escaping () -> Void
  ) {
    self.type = type
    self.leftAction = leftAction
    self.rightAcition = rightAcition
  }
}

// MARK: - View
extension MeasureFinishModal {
  var body: some View {
    ZStack {
      Color.B_00.opacity(0.75).ignoresSafeArea()
      
      VStack(alignment: .center) {
        Text(type.title)
          .font(.FontSystem.h2)
          .foregroundStyle(.B_00)
          .padding(.bottom, 10)
        
        if type == .longEnough {
          Text(type.caption)
            .font(.FontSystem.b1)
            .foregroundStyle(.B_30)
            .multilineTextAlignment(.center)
            .padding(.bottom, 16)
        } else {
          VStack(spacing: 3) {
            HStack(spacing: 0) {
              Text("10분 이상 측정해야 결과를 확인")
                .foregroundStyle(.BR_05)
              Text("할 수 있어요.")
                .foregroundStyle(.B_30)
            }
            Text("그래도 종료할까요?")
              .foregroundStyle(.B_30)
          }
          .font(.FontSystem.b1)
          .multilineTextAlignment(.center)
          .padding(.bottom, 16)
        }
        
        HStack(spacing: 25) {
          Button {
            leftAction()
          } label: {
            Text("이어하기")
              .font(.FontSystem.h4)
              .foregroundStyle(.B_20)
              .frame(width: 130, height: 56)
              .background(.clear)
              .clipShape(RoundedRectangle(cornerRadius: 15))
              .overlay(
                RoundedRectangle(cornerRadius: 15)
                  .stroke(.B_40, lineWidth: 1)
              )
          }
          .buttonStyle(.plain)
          
          Button {
            rightAcition()
          } label: {
            Text("종료하기")
              .font(.FontSystem.h4)
              .foregroundStyle(.W_10)
              .frame(width: 130, height: 56)
              .background(.BR_00)
              .clipShape(RoundedRectangle(cornerRadius: 15))
          }
          .buttonStyle(.plain)
        }
      }
      .frame(maxWidth: .infinity)
      .frame(height: 210)
      .background(.W_00)
      .clipShape(RoundedRectangle(cornerRadius: 20))
      .padding(.horizontal, 25)
    }
  }
}

#Preview {
  MeasureFinishModal(type: .longEnough, leftAction: { print("Left") }, rightAcition: { print("Right") })
}
