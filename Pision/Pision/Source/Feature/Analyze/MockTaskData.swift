//
//  MockTaskData.swift
//  Pision
//
//  Created by rundo on 7/24/25.
//

import Foundation

extension TaskData {
  static var mock: TaskData {
    TaskData(
      startTime: Date(),
      endTime: Date().addingTimeInterval(4 * 60 * 60), // 4시간 후
      averageScore: 78,
      focusRatio: [
        85, 90, 75, 80, 70, 65,  // 첫 1시간: 높은 집중도
        60, 55, 50, 45, 40, 35,  // 둘째 시간: 집중도 하락
        30, 35, 40, 50, 60, 70,  // 셋째 시간: 회복
        75, 80, 85, 90, 88, 82   // 넷째 시간: 안정적 집중
      ], // 24개 (10분 단위)
      focusTime: 10800, // 3시간 집중 (초)
      durationTime: 14400, // 4시간 전체 (초)
      snoozeImageDatas: [
        Data([
          0, 0, 0, 44, 102, 116, 121, 112, 104, 101, 105, 99,
          0, 0, 0, 0, 109, 105, 102, 49, 77, 105, 72, 66,
          77, 105, 72, 69, 77, 105, 80, 114, 109, 105, 97, 102,
          104, 101, 105, 99, 116, 109, 97, 112, 0, 0, 144, 59,
          109, 101, 116, 97, 0, 0, 0, 0, 0, 0, 0, 33,
          104, 100, 108, 114
        ])
      ],
      
      avgCoreDatas: [
        // 첫 번째 시간 (6개) - 높은 집중도
        AvgCoreScore(avgYawScore: 35, avgEyeOpenScore: 22, avgEyeClosedScore: 8, avgBlinkFrequency: 12, avgCoreScore: 85),
        AvgCoreScore(avgYawScore: 38, avgEyeOpenScore: 24, avgEyeClosedScore: 6, avgBlinkFrequency: 10, avgCoreScore: 90),
        AvgCoreScore(avgYawScore: 32, avgEyeOpenScore: 20, avgEyeClosedScore: 10, avgBlinkFrequency: 14, avgCoreScore: 75),
        AvgCoreScore(avgYawScore: 36, avgEyeOpenScore: 23, avgEyeClosedScore: 7, avgBlinkFrequency: 11, avgCoreScore: 80),
        AvgCoreScore(avgYawScore: 30, avgEyeOpenScore: 19, avgEyeClosedScore: 12, avgBlinkFrequency: 15, avgCoreScore: 70),
        AvgCoreScore(avgYawScore: 28, avgEyeOpenScore: 18, avgEyeClosedScore: 14, avgBlinkFrequency: 13, avgCoreScore: 65),
        
        // 두 번째 시간 (6개) - 집중도 하락
        AvgCoreScore(avgYawScore: 25, avgEyeOpenScore: 16, avgEyeClosedScore: 16, avgBlinkFrequency: 12, avgCoreScore: 60),
        AvgCoreScore(avgYawScore: 22, avgEyeOpenScore: 15, avgEyeClosedScore: 18, avgBlinkFrequency: 11, avgCoreScore: 55),
        AvgCoreScore(avgYawScore: 20, avgEyeOpenScore: 14, avgEyeClosedScore: 20, avgBlinkFrequency: 10, avgCoreScore: 50),
        AvgCoreScore(avgYawScore: 18, avgEyeOpenScore: 13, avgEyeClosedScore: 17, avgBlinkFrequency: 9, avgCoreScore: 45),
        AvgCoreScore(avgYawScore: 16, avgEyeOpenScore: 12, avgEyeClosedScore: 19, avgBlinkFrequency: 8, avgCoreScore: 40),
        AvgCoreScore(avgYawScore: 15, avgEyeOpenScore: 11, avgEyeClosedScore: 20, avgBlinkFrequency: 7, avgCoreScore: 35),
        
        // 세 번째 시간 (6개) - 회복
        AvgCoreScore(avgYawScore: 17, avgEyeOpenScore: 12, avgEyeClosedScore: 19, avgBlinkFrequency: 8, avgCoreScore: 30),
        AvgCoreScore(avgYawScore: 20, avgEyeOpenScore: 14, avgEyeClosedScore: 17, avgBlinkFrequency: 9, avgCoreScore: 35),
        AvgCoreScore(avgYawScore: 24, avgEyeOpenScore: 16, avgEyeClosedScore: 15, avgBlinkFrequency: 11, avgCoreScore: 40),
        AvgCoreScore(avgYawScore: 28, avgEyeOpenScore: 18, avgEyeClosedScore: 13, avgBlinkFrequency: 13, avgCoreScore: 50),
        AvgCoreScore(avgYawScore: 32, avgEyeOpenScore: 20, avgEyeClosedScore: 11, avgBlinkFrequency: 14, avgCoreScore: 60),
        AvgCoreScore(avgYawScore: 35, avgEyeOpenScore: 22, avgEyeClosedScore: 9, avgBlinkFrequency: 12, avgCoreScore: 70),
        
        // 네 번째 시간 (6개) - 안정적 집중
        AvgCoreScore(avgYawScore: 37, avgEyeOpenScore: 23, avgEyeClosedScore: 7, avgBlinkFrequency: 11, avgCoreScore: 75),
        AvgCoreScore(avgYawScore: 39, avgEyeOpenScore: 24, avgEyeClosedScore: 5, avgBlinkFrequency: 10, avgCoreScore: 80),
        AvgCoreScore(avgYawScore: 40, avgEyeOpenScore: 25, avgEyeClosedScore: 3, avgBlinkFrequency: 8, avgCoreScore: 85),
        AvgCoreScore(avgYawScore: 38, avgEyeOpenScore: 25, avgEyeClosedScore: 2, avgBlinkFrequency: 7, avgCoreScore: 90),
        AvgCoreScore(avgYawScore: 37, avgEyeOpenScore: 24, avgEyeClosedScore: 4, avgBlinkFrequency: 9, avgCoreScore: 88),
        AvgCoreScore(avgYawScore: 35, avgEyeOpenScore: 23, avgEyeClosedScore: 6, avgBlinkFrequency: 10, avgCoreScore: 82)
      ],
      avgAuxDatas: [
        // 첫 번째 시간 (6개) - 높은 집중도
        AvgAuxScore(avgBlinkScore: 20, avgYawStabilityScore: 22, avgMlSnoozeScore: 45, avgAuxScore: 85),
        AvgAuxScore(avgBlinkScore: 18, avgYawStabilityScore: 24, avgMlSnoozeScore: 48, avgAuxScore: 90),
        AvgAuxScore(avgBlinkScore: 22, avgYawStabilityScore: 20, avgMlSnoozeScore: 42, avgAuxScore: 75),
        AvgAuxScore(avgBlinkScore: 19, avgYawStabilityScore: 23, avgMlSnoozeScore: 46, avgAuxScore: 80),
        AvgAuxScore(avgBlinkScore: 24, avgYawStabilityScore: 18, avgMlSnoozeScore: 40, avgAuxScore: 70),
        AvgAuxScore(avgBlinkScore: 25, avgYawStabilityScore: 16, avgMlSnoozeScore: 38, avgAuxScore: 65),
        
        // 두 번째 시간 (6개) - 집중도 하락
        AvgAuxScore(avgBlinkScore: 23, avgYawStabilityScore: 15, avgMlSnoozeScore: 35, avgAuxScore: 60),
        AvgAuxScore(avgBlinkScore: 22, avgYawStabilityScore: 14, avgMlSnoozeScore: 32, avgAuxScore: 55),
        AvgAuxScore(avgBlinkScore: 21, avgYawStabilityScore: 13, avgMlSnoozeScore: 30, avgAuxScore: 50),
        AvgAuxScore(avgBlinkScore: 20, avgYawStabilityScore: 12, avgMlSnoozeScore: 28, avgAuxScore: 45),
        AvgAuxScore(avgBlinkScore: 19, avgYawStabilityScore: 11, avgMlSnoozeScore: 25, avgAuxScore: 40),
        AvgAuxScore(avgBlinkScore: 18, avgYawStabilityScore: 10, avgMlSnoozeScore: 22, avgAuxScore: 35),
        
        // 세 번째 시간 (6개) - 회복
        AvgAuxScore(avgBlinkScore: 17, avgYawStabilityScore: 11, avgMlSnoozeScore: 20, avgAuxScore: 30),
        AvgAuxScore(avgBlinkScore: 18, avgYawStabilityScore: 12, avgMlSnoozeScore: 25, avgAuxScore: 35),
        AvgAuxScore(avgBlinkScore: 20, avgYawStabilityScore: 14, avgMlSnoozeScore: 30, avgAuxScore: 40),
        AvgAuxScore(avgBlinkScore: 22, avgYawStabilityScore: 16, avgMlSnoozeScore: 35, avgAuxScore: 50),
        AvgAuxScore(avgBlinkScore: 24, avgYawStabilityScore: 18, avgMlSnoozeScore: 40, avgAuxScore: 60),
        AvgAuxScore(avgBlinkScore: 23, avgYawStabilityScore: 20, avgMlSnoozeScore: 42, avgAuxScore: 70),
        
        // 네 번째 시간 (6개) - 안정적 집중
        AvgAuxScore(avgBlinkScore: 21, avgYawStabilityScore: 22, avgMlSnoozeScore: 46, avgAuxScore: 75),
        AvgAuxScore(avgBlinkScore: 19, avgYawStabilityScore: 24, avgMlSnoozeScore: 48, avgAuxScore: 80),
        AvgAuxScore(avgBlinkScore: 17, avgYawStabilityScore: 25, avgMlSnoozeScore: 50, avgAuxScore: 85),
        AvgAuxScore(avgBlinkScore: 15, avgYawStabilityScore: 25, avgMlSnoozeScore: 50, avgAuxScore: 90),
        AvgAuxScore(avgBlinkScore: 16, avgYawStabilityScore: 24, avgMlSnoozeScore: 49, avgAuxScore: 88),
        AvgAuxScore(avgBlinkScore: 18, avgYawStabilityScore: 23, avgMlSnoozeScore: 47, avgAuxScore: 82)
      ]
    )
  }
}
