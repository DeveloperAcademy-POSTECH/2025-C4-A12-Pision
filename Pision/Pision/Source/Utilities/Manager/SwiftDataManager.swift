//
//  SwiftDataManager.swift
//  Pision
//
//  Created by 여성일 on 7/24/25.
//

import SwiftData
import Foundation

final class SwiftDataManager {
  /// 사용자의 집중 측정 데이터를 SwiftData에 저장합니다.
  ///
  /// - Parameters:
  ///   - context: SwiftData의 `ModelContext` 인스턴스입니다.
  ///   - taskData: 저장할 사용자 측정 데이터 (`TaskDataModel` 타입)입니다.
  func saveTaskDataToSwiftData(
    context: ModelContext,
    taskData: TaskDataModel
  ) {
    // 30초 단위 Core 점수들을 SwiftData 모델로 변환
    let coreModels = taskData.coreScoreSegments.map {
      AvgCoreScore(
        avgYawScore: $0.yawScore,
        avgEyeOpenScore: $0.eyeOpenScore,
        avgEyeClosedScore: $0.eyeClosedScore,
        avgBlinkFrequency: $0.blinkFrequency,
        avgCoreScore: $0.coreScore
      )
    }
    
    // 30초 단위 Aux 점수들을 SwiftData 모델로 변환
    let auxModels = taskData.auxScoreSegments.map {
      AvgAuxScore(
        avgBlinkScore: $0.blinkScore,
        avgYawStabilityScore: $0.yawStabilityScore,
        avgMlSnoozeScore: $0.mlSnoozeScore,
        avgAuxScore: $0.auxScore
      )
    }
    
    // 집중도 관련 데이터 계산
    let calculatedFocusRatio = taskData.calculateFocusRatio()
    let calculatedFocusTime = taskData.calculateFocusTime()
    let totalScorePerSegment = taskData.totalScorePerSegment()
    
    let taskDataEntity = TaskData(
      startTime: taskData.startTime,
      endTime: taskData.endTime,
      averageScore: taskData.averageScore,
      focusRatio: totalScorePerSegment, // 각 구간별 점수 저장
      focusTime: calculatedFocusTime,
      durationTime: taskData.durationTime,
      snoozeImageDatas: taskData.snoozeImageDatas,
      avgCoreDatas: coreModels,
      avgAuxDatas: auxModels
    )
    
    context.insert(taskDataEntity)
    
    do {
      try context.save()
      print("✅ SwiftData 저장 성공")
      print("📊 저장된 데이터:")
      print("   - 측정 시간: \(taskData.durationTime)초")
      print("   - 집중 시간: \(calculatedFocusTime)초")
      print("   - 집중 비율: \(String(format: "%.1f", calculatedFocusRatio * 100))%")
      print("   - 30초 구간 수: \(taskData.coreScoreSegments.count)개")
      print("   - 평균 점수: \(String(format: "%.1f", taskData.averageScore))")
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
      
      print("\n🗃️ 저장된 TaskData 총 \(results.count)개")
      print("=====================================")
      
      for (i, task) in results.enumerated() {
        print("""
        \n====== TaskData [\(i + 1)] ======
        📅 측정 일시: \(formatDate(task.startTime)) ~ \(formatDate(task.endTime))
        ⏱️ 총 측정 시간: \(formatDuration(task.durationTime))
        🎯 집중 시간: \(formatDuration(task.focusTime))
        📊 평균 점수: \(String(format: "%.1f", task.averageScore))점
        📈 집중 비율: \(String(format: "%.1f", task.calculateFocusRatio() * 100))%
        🔢 30초 구간 수: \(task.segmentCount)개
        📸 스누즈 사진: \(task.snoozeImageDatas.count)장
        """)
        
        // 구간별 점수 요약 (최고/최저/평균)
        if !task.focusRatio.isEmpty {
          let bestScore = task.bestSegmentScore()
          let worstScore = task.worstSegmentScore()
          let avgScore = task.focusRatio.reduce(0, +) / Float(task.focusRatio.count)
          
          print("""
          📊 구간별 점수 요약:
          - 최고 점수: \(String(format: "%.1f", bestScore))점
          - 최저 점수: \(String(format: "%.1f", worstScore))점
          - 구간 평균: \(String(format: "%.1f", avgScore))점
          """)
        }
        
        // Core 점수 상세 정보 (처음 3구간만 표시)
        print("🎯 Core 점수 상세 (처음 3구간):")
        for (j, core) in task.avgCoreDatas.prefix(3).enumerated() {
          print("""
          구간[\(j + 1)]: \(String(format: "%.1f", core.avgCoreScore))점
          - 고개 회전: \(String(format: "%.1f", core.avgYawScore))
          - 눈 뜸 정도: \(String(format: "%.1f", core.avgEyeOpenScore))
          - 눈 감음 비율: \(String(format: "%.1f", core.avgEyeClosedScore))
          - 깜빡임 빈도: \(String(format: "%.1f", core.avgBlinkFrequency))
          """)
        }
        
        // Aux 점수 상세 정보 (처음 3구간만 표시)
        print("⚡ Aux 점수 상세 (처음 3구간):")
        for (j, aux) in task.avgAuxDatas.prefix(3).enumerated() {
          print("""
          구간[\(j + 1)]: \(String(format: "%.1f", aux.avgAuxScore))점
          - 깜빡임 점수: \(String(format: "%.1f", aux.avgBlinkScore))
          - 고개 안정성: \(String(format: "%.1f", aux.avgYawStabilityScore))
          - ML 스누즈: \(String(format: "%.1f", aux.avgMlSnoozeScore))
          """)
        }
        
        if task.avgCoreDatas.count > 3 {
          print("... 외 \(task.avgCoreDatas.count - 3)개 구간")
        }
        
        print("==============================")
      }
      print("=====================================\n")
      
    } catch {
      print("❌ TaskData 불러오기 실패: \(error)")
    }
  }
  
  /// 특정 조건으로 TaskData를 필터링하여 가져옵니다.
  ///
  /// - Parameters:
  ///   - context: SwiftData의 `ModelContext` 인스턴스
  ///   - minDuration: 최소 측정 시간 (초, 기본값: 0)
  ///   - minScore: 최소 평균 점수 (기본값: 0.0)
  ///   - limit: 최대 결과 개수 (기본값: nil - 제한 없음)
  /// - Returns: 필터링된 TaskData 배열
  func fetchTaskData(
    context: ModelContext,
    minDuration: Int = 0,
    minScore: Float = 0.0,
    limit: Int? = nil
  ) -> [TaskData] {
    let fetchDescriptor = FetchDescriptor<TaskData>()
    
    do {
      let results = try context.fetch(fetchDescriptor)
      
      // 조건 필터링 및 정렬
      let filteredResults = results
        .filter { task in
          task.durationTime >= minDuration && task.averageScore >= minScore
        }
        .sorted { $0.startTime > $1.startTime } // 최신순 정렬
      
      // 제한 적용
      let finalResults = limit != nil ? Array(filteredResults.prefix(limit!)) : filteredResults
      
      print("📋 필터링 결과: \(finalResults.count)개 (전체: \(results.count)개)")
      return finalResults
      
    } catch {
      print("❌ TaskData 필터링 실패: \(error)")
      return []
    }
  }
  
  /// 특정 TaskData를 삭제합니다.
  ///
  /// - Parameters:
  ///   - context: SwiftData의 `ModelContext` 인스턴스
  ///   - taskData: 삭제할 TaskData
  func deleteTaskData(context: ModelContext, taskData: TaskData) {
    context.delete(taskData)
    
    do {
      try context.save()
      print("✅ TaskData 삭제 성공")
    } catch {
      print("❌ TaskData 삭제 실패: \(error)")
    }
  }
  
  /// 모든 TaskData를 삭제합니다.
  ///
  /// - Parameter context: SwiftData의 `ModelContext` 인스턴스
  func deleteAllTaskData(context: ModelContext) {
    let fetchDescriptor = FetchDescriptor<TaskData>()
    
    do {
      let results = try context.fetch(fetchDescriptor)
      
      for taskData in results {
        context.delete(taskData)
      }
      
      try context.save()
      print("✅ 모든 TaskData 삭제 성공 (\(results.count)개)")
      
    } catch {
      print("❌ TaskData 전체 삭제 실패: \(error)")
    }
  }
}

// MARK: - Private Helper Methods
private extension SwiftDataManager {
  /// 날짜를 읽기 쉬운 형태로 포맷팅합니다.
  func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM/dd HH:mm"
    return formatter.string(from: date)
  }
  
  /// 초 단위 시간을 읽기 쉬운 형태로 포맷팅합니다.
  func formatDuration(_ seconds: Int) -> String {
    let hours = seconds / 3600
    let minutes = (seconds % 3600) / 60
    let secs = seconds % 60
    
    if hours > 0 {
      return String(format: "%d시간 %d분 %d초", hours, minutes, secs)
    } else if minutes > 0 {
      return String(format: "%d분 %d초", minutes, secs)
    } else {
      return String(format: "%d초", secs)
    }
  }
}
