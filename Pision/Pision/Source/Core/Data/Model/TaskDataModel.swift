//
//  TaskDataModel.swift
//  Pision
//
//  Created by 여성일 on 7/23/25.
//

import Foundation

struct TaskDataModel {
  let startTime: Date
  let endTime: Date
  let averageScore: Float
  let focusRatio: [Float]
  let focusTime: Int
  let durationTime: Int
  let snoozeImageDatas: [Data]
  let avgCoreDatas: [AvgCoreScoreModel]
  let avgAuxDatas: [AvgAuxScoreModel]
}

