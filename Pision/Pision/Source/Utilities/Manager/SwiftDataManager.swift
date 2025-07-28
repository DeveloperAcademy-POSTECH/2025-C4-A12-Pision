//
//  SwiftDataManager.swift
//  Pision
//
//  Created by 여성일 on 7/24/25.
//

import SwiftData

final class SwiftDataManager {
  /// 사용자의 집중 측정 데이터를 SwiftData에 저장합니다.
  ///
  /// - Parameters:
  ///   - context: SwiftData의 `ModelContext` 인스턴스입니다.
  ///   - taskData: 저장할 사용자 측정 데이터 (`TaskDataModel` 타입)입니다.
  ///   - completion: 저장 성공 여부를 `Bool`로 반환하는 완료 핸들러입니다.
  func saveTaskDataToSwiftData(
    context: ModelContext,
    taskData: TaskDataModel,
  ) {
    let coreModels = taskData.avgCoreDatas.map {
      AvgCoreScore(
        avgYawScore: $0.avgYawScore,
        avgEyeOpenScore: $0.avgEyeOpenScore,
        avgEyeClosedScore: $0.avgEyeClosedScore,
        avgBlinkFrequency: $0.avgBlinkFrequency,
        avgCoreScore: $0.avgCoreScore
      )
    }
    
    let auxModels = taskData.avgAuxDatas.map {
      AvgAuxScore(
        avgBlinkScore: $0.avgBlinkScore,
        avgYawStabilityScore: $0.avgYawStabilityScore,
        avgMlSnoozeScore: $0.avgMlSnoozeScore,
        avgAuxScore: $0.avgAuxScore
      )
    }
    
    let taskData = TaskData(
      startTime: taskData.startTime,
      endTime: taskData.endTime,
      averageScore: taskData.averageScore,
      focusRatio: taskData.focusRatio,
      focusTime: taskData.focusTime,
      durationTime: taskData.durationTime,
      snoozeImageDatas: taskData.snoozeImageDatas,
      avgCoreDatas: coreModels,
      avgAuxDatas: auxModels
    )
    
    context.insert(taskData)
    
    do {
      try context.save()
      print("✅ SwiftData 저장 성공")
    } catch {
      print("❌ SwiftData 저장 실패: \(error)")
    }
  }
  
  /// SwiftData에서 모든 TaskData를 불러와 콘솔에 출력합니다.
  ///
  /// - Parameter context: SwiftData의 `ModelContext` 인스턴스입니다.
  func fetchAllTaskData(context: ModelContext) {
    let fetchDescriptor = FetchDescriptor<TaskData>()
    
    do {
      let results = try context.fetch(fetchDescriptor)
      
      for (i, task) in results.enumerated() {
        print("""
        \n====== TaskData [\(i + 1)] ======
        startTime: \(task.startTime)
        endTime: \(task.endTime)
        averageScore: \(task.averageScore)
        durationTime: \(task.durationTime)초
        focusTime: \(task.focusTime)초
        focusRatio: \(task.focusRatio)
        """)
        
        print("avgCoreDatas \(task.avgCoreDatas.count)개")
        for (j, core) in task.avgCoreDatas.enumerated() {
          print("""
          avgCoreDatas[\(j + 1)]
          - avgYawScore: \(core.avgYawScore)
          - avgEyeOpenScore: \(core.avgEyeOpenScore)
          - avgEyeClosedScore: \(core.avgEyeClosedScore)
          - agBlinkFrequency: \(core.avgBlinkFrequency)
          - avgCoreScore: \(core.avgCoreScore)
          """)
        }
        
        print("avgAuxDatas \(task.avgAuxDatas.count)개")
        for (j, aux) in task.avgAuxDatas.enumerated() {
          print("""
          avgAuxDatas[\(j + 1)]
          - avgBlinkScore: \(aux.avgBlinkScore)
          - avgYawStabilityScore: \(aux.avgYawStabilityScore)
          - avgMLSnoozeScore: \(aux.avgMlSnoozeScore)
          - avgAuxScore: \(aux.avgAuxScore)
          """)
        }
        print("==============================\n")
      }
    } catch {
      print("TaskData 불러오기 실패: \(error)")
    }
  }
}
