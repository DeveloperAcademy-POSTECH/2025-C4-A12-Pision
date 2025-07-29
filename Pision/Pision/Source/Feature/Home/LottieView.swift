//
//  LottieView.swift
//  Pision
//
//  Created by YONGWON SEO on 7/28/25.
//

import SwiftUI
import Lottie

//MARK: Var
struct LottieView:UIViewRepresentable{
  private let animation: String
  init(
    animation: String
  ) {
    self.animation = animation
  }
}

//MARK: View
extension LottieView{
  
}

//MARK: func
extension LottieView{
  func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
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
  
  func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
  }
}


#Preview {
  LottieView(animation:"zipzoongi")
}
