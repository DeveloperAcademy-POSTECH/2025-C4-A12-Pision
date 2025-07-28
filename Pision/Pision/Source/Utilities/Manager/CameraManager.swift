//
//  CameraManager.swift
//  Pision
//
//  Created by 여성일 on 7/9/25.
//

import AVFoundation
import UIKit

// MARK: - CameraManager
final class CameraManager: NSObject {
  let session = AVCaptureSession()

  private var lastCaptureDate: Date? = nil
  private var isGuiding: Bool = false
  private var isMeasuring: Bool = false
  private let photoOutput = AVCapturePhotoOutput()
  private let videoOutput = AVCaptureVideoDataOutput()
  private var isSessionConfigured = false
  private let sessionQueue = DispatchQueue(label: "CameraSessionQueue")
  
  private let visionManager: VisionManager
  var onPhotoCaptured: ((Data) -> Void)?
  
  init(visionManager: VisionManager) {
    self.visionManager = visionManager
    super.init()
  }
}

// MARK: - General Func
extension CameraManager {
  /// 캡처 세션을 시작합니다.
  /// `sessionQueue`에서 비동기적으로 실행되며, 이미 실행 중인 경우는 무시합니다.
  func startSession() {
    sessionQueue.async {
      if !self.session.isRunning {
        self.session.startRunning()
      }
    }
  }
  
  /// 캡처 세션을 중지합니다.
  /// `sessionQueue`에서 비동기적으로 실행되며, 실행 중이 아닐 경우는 무시합니다.
  func stopSession() {
    sessionQueue.async {
      if self.session.isRunning {
        self.session.stopRunning()
      }
    }
  }
  
  /// 가이드를 시작합니다.
  /// 내부 상태 변수 `isGuiding`을 `true`로 설정합니다.
  func startGuiding() {
    isGuiding = true
  }
  
  /// 가이드를 중단합니다.
  /// 내부 상태 변수 `isGuiding`을 `false`로 설정합니다.
  func stopGuiding() {
    isGuiding = false
  }
  
  /// 측정을 시작합니다.
  /// 내부 상태 변수 `isMeasuring`을 `true`로 설정합니다.
  func startMeasuring() {
    isMeasuring = true
  }
  
  /// 측정을 중단합니다.
  /// 내부 상태 변수 `isMeasuring`을 `false`로 설정합니다.
  func stopMeasuring() {
    isMeasuring = false
  }
  
  /// 카메라 권한을 요청하고, 허용된 경우 세션 구성을 진행합니다.
  /// 이미 권한이 있는 경우 바로 구성하며, 거부된 경우 로그만 출력합니다.
  func requestAndCheckPermissions() {
    switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .notDetermined:
      AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
        if granted {
          self?.configureSessionIfNeeded()
        } else {
          print("카메라 접근 거부됨")
        }
      }
      
    case .authorized:
      configureSessionIfNeeded()
    case .restricted, .denied:
      print("카메라 접근 제한 또는 거부")
    @unknown default:
      print("알 수 없는 권한 상태")
    }
  }
  
  func captureSnoozePhoto() {
    let settings = AVCapturePhotoSettings()
    let now = Date()
    
    if let last = lastCaptureDate, now.timeIntervalSince(last) < 600 {
      return
    }
    
    lastCaptureDate = now
    photoOutput.capturePhoto(with: settings, delegate: self)
  }
}

// MARK: - Private Func
extension CameraManager {
  /// 세션이 아직 구성되지 않은 경우 한 번만 세션을 구성합니다.
  /// `isSessionConfigured` 플래그를 이용해 중복 구성을 방지합니다.
  private func configureSessionIfNeeded() {
    guard !isSessionConfigured else { return }
    isSessionConfigured = true
    configureSession()
  }
  
  /// 캡처 세션을 구성합니다.
  /// 프론트 카메라를 입력으로 설정하고, 비디오 출력 설정 및 델리게이트를 등록합니다.
  private func configureSession() {
    session.beginConfiguration()
    session.sessionPreset = .high
    
    guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
          let input = try? AVCaptureDeviceInput(device: device),
          session.canAddInput(input) else {
      print("카메라 인풋 실패")
      session.commitConfiguration()
      return
    }
    
    session.addInput(input)
    
    if session.canAddOutput(videoOutput) {
      videoOutput.videoSettings = [
        kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA
      ]
      videoOutput.setSampleBufferDelegate(self, queue: sessionQueue)
      videoOutput.alwaysDiscardsLateVideoFrames = true
      session.addOutput(videoOutput)
      
      if #available(iOS 17.0, *) {
        videoOutput.connections.first?.videoRotationAngle = 0
      } else {
        videoOutput.connections.first?.videoOrientation = .portrait
      }
    }
    
    if session.canAddOutput(photoOutput) {
      session.addOutput(photoOutput)
    }
    
    session.commitConfiguration()
  }
}

// MARK: - Delegate
extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
  func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
    if isMeasuring {
      visionManager.processMeasureFaceLandMark(pixelBuffer: pixelBuffer)
      visionManager.processMeasureBodyPose(pixelBuffer: pixelBuffer)
    }
    
    if isGuiding {
      visionManager.processGuidingBodyPose(pixelBuffer: pixelBuffer)
      visionManager.processGuidingFaceLandMark(pixelBuffer: pixelBuffer)
      visionManager.processHandPose(pixelBuffer: pixelBuffer)
    }
  }
}

extension CameraManager: AVCapturePhotoCaptureDelegate {
  func photoOutput(_ output: AVCapturePhotoOutput,
                   didFinishProcessingPhoto photo: AVCapturePhoto,
                   error: (any Error)?) {
    guard error == nil,
          let data = photo.fileDataRepresentation()
    else {
      print("캡처 실패")
      return
    }
  
    print("캡처 호출")
    onPhotoCaptured?(data)
  }
}
