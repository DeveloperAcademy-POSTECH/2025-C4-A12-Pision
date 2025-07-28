//
//  enum + Route.swift
//  Pision
//
//  Created by 여성일 on 7/29/25.
//

enum Route: Hashable {
  case home
  case measure
  case guidingCamera
  case guidingPose
  case loading
  case analyze(TaskData)
}
