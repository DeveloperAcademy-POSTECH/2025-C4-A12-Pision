//
//  LottieView.swift
//  Pision
//
//  Created by YONGWON SEO on 7/28/25.
//

import SwiftUI
import Lottie

//MARK: Var
struct CustomLottieView:UIViewRepresentable{
  private let animation: String
  
  init(
    animation: String
  ) {
    self.animation = animation
  }
}

//MARK: View
extension CustomLottieView{
  
}

//MARK: func
extension CustomLottieView{
  func makeUIView(context: UIViewRepresentableContext<CustomLottieView>) -> UIView {
    let view = UIView(frame: .zero)
    let animationView = LottieAnimationView(name:animation)
    
    animationView.frame = view.bounds
    
    animationView.contentMode = .scaleAspectFit
    animationView.loopMode = .loop
    animationView.animationSpeed = 1
    view.addSubview(animationView)
    
    animationView.play()
    
    NSLayoutConstraint.activate([
      animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
      animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
    ])
    animationView.translatesAutoresizingMaskIntoConstraints = false
    
    return view
  }
  
  func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<CustomLottieView>) {
  }
}


#Preview {
  CustomLottieView(animation:"zipzoongi")
}
