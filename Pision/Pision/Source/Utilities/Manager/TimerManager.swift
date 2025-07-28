//
//  TimerManager.swift
//  Pision
//
//  Created by 여성일 on 7/28/25.
//

import Foundation

// MARK: - General
final class TimerManager {
  // Internal
  private var timer: Timer?
  private var autoDimWorkItem: DispatchWorkItem?
  private(set) var secondsElapsed:Int = 0
  
  // CallBack
  var onTick: ((Int) -> Void)?
  var onAutoDim: (() -> Void)?
}

// MARK: - Method
extension TimerManager {
  func timerStart() {
    secondsElapsed = 0
    startTimerLoop()
  }
  
  func timerPause() {
    timer?.invalidate()
    timer = nil
  }
  
  func timerResume() {
    guard timer == nil else { return }
    startTimerLoop()
  }
  
  func timerStop() {
    timer?.invalidate()
    timer = nil
    cancelAutoDim()
  }
    
  func startTimerLoop() {
    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
      guard let self = self else { return }
      self.secondsElapsed += 1
      onTick?(self.secondsElapsed)
    })
  }
  
  func startAutoDim() {
    cancelAutoDim()
    let work = DispatchWorkItem {
      self.onAutoDim?()
    }
    autoDimWorkItem = work
    DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: work)
  }
  
  func cancelAutoDim() {
    autoDimWorkItem?.cancel()
    autoDimWorkItem = nil
  }
  
  func resetAutoDim() {
    startAutoDim()
  }
}
