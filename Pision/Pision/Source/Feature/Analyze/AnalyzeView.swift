// MARK: - 라이브러리 임포트
import SwiftUI          // SwiftUI 프레임워크: UI 구성
import Charts           // Swift Charts 프레임워크: 그래프 시각화

// MARK: - 데이터 모델
struct ConcentrationData: Identifiable {     // List·ForEach에서 구분하기 위해 Identifiable 채택
    let id = UUID()                          // 각 데이터 항목을 고유하게 식별할 UUID
    let timestamp: Date                      // 측정 시각
    let blinkRate: Double                    // 분당 깜빡임 횟수
    let headMovement: Double                 // 머리 움직임 정도 (0-100, 클수록 많이 움직임)
    let drowsinessLevel: Double              // 졸음 지수 (0-100, 클수록 졸림)
    
    // MARK: - 계산 프로퍼티: 실시간 집중도(0-100) 산출
    var concentrationScore: Double {
        // 깜빡임 점수: 정상(15회/분)에서 멀어질수록 감점, 최소 0점
        let blinkScore = max(0, 100 - (blinkRate - 15) * 2)
        // 머리 움직임 점수: 많이 움직일수록 감점
        let movementScore = max(0, 100 - headMovement)
        // 졸음 점수: 졸음 지수 높을수록 감점
        let alertnessScore = max(0, 100 - drowsinessLevel)
        
        // 세 항목을 가중합(30 %·30 %·40 %)으로 최종 집중도 산출
        return (blinkScore * 0.3 + movementScore * 0.3 + alertnessScore * 0.4)
    }
}

// MARK: - ViewModel
class AnalyzeViewModel: ObservableObject {          // UI와 상태를 연결하기 위해 ObservableObject 채택
    @Published var concentrationData: [ConcentrationData] = []   // 그래프 데이터
    @Published var totalFocusTime: TimeInterval = 0              // 누적 집중 시간(초)
    @Published var averageConcentration: Double = 0              // 평균 집중도
    
    init() {
        generateDummyData()      // (예시) 더미 데이터 생성
        calculateStatistics()    // 통계값 계산
    }
    
    // MARK: 더미 데이터 생성 (5분 간격, 최근 2시간)
    private func generateDummyData() {
        let calendar = Calendar.current
        let now = Date()
        
        for i in 0..<24 {    // 24 × 5분 = 120분(2시간)
            let timestamp = calendar.date(byAdding: .minute, value: -i * 5, to: now)!
            
            // 시간대별 패턴 변화를 주기 위한 사인 곡선
            let timeVariation = sin(Double(i) * 0.3) * 20
            
            // 랜덤값 + 패턴으로 세 지표 생성
            let data = ConcentrationData(
                timestamp: timestamp,
                blinkRate: Double.random(in: 10...25) + timeVariation * 0.2,
                headMovement: Double.random(in: 5...40) + timeVariation,
                drowsinessLevel: Double.random(in: 0...30) + max(0, timeVariation)
            )
            concentrationData.append(data)
        }
        
        concentrationData.reverse()   // 과거→현재 순서를 현재→과거로 뒤집기
    }
    
    // MARK: 통계 계산
    private func calculateStatistics() {
        // 집중도가 70점 이상인 구간만 필터 → 집중 시간 계산
        let focusedData = concentrationData.filter { $0.concentrationScore >= 70 }
        totalFocusTime = Double(focusedData.count) * 5 * 60   // 5분 × n → 초
        
        // 전체 평균 집중도
        let totalScore = concentrationData.reduce(0) { $0 + $1.concentrationScore }
        averageConcentration = totalScore / Double(concentrationData.count)
    }
}

// MARK: - 메인 뷰
struct AnalyzeView: View {
    @StateObject private var viewModel = AnalyzeViewModel()      // ViewModel 바인딩
    @Environment(\.dismiss) var dismiss                          // 뒤로가기 제어
    
    var body: some View {
        ScrollView {                 // 콘텐츠가 화면을 넘치면 스크롤
            VStack(spacing: 24) {    // 섹션 간 간격 24
                statisticsSection    // 상단 통계 카드
                concentrationChart   // 집중도 추이 차트
                detailChartsSection  // 깜빡임·머리움직임·졸음 차트
            }
            .padding()               // 전체 패딩
        }
        .background(Color(.systemGroupedBackground))   // iOS 기본 그룹 배경색
        .navigationTitle("집중도 분석")                 // 대제목
        .navigationBarTitleDisplayMode(.large)         // 큰 타이틀
        .navigationBarBackButtonHidden(true)           // 기본 뒤로버튼 숨김
        .toolbar {                                     // 커스텀 툴바
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()                          // 뷰 닫기
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("뒤로")
                    }
                }
            }
        }
    }
    
    // MARK: - (1) 상단 통계 카드 섹션
    private var statisticsSection: some View {
        VStack(spacing: 16) {
            HStack {
                // ⓐ 전체 집중 시간
                VStack(alignment: .leading, spacing: 8) {
                    Text("전체 집중 시간")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text(formatTime(viewModel.totalFocusTime))   // 시간 형식 변환
                        .font(.system(size: 36, weight: .bold))
                }
                Spacer()
                // ⓑ 평균 집중도
                VStack(alignment: .trailing, spacing: 8) {
                    Text("평균 집중도")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 4) {
                        Text("\(Int(viewModel.averageConcentration))")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(concentrationColor(viewModel.averageConcentration))
                        Text("%")
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))  // 카드 배경
            .cornerRadius(12)
            .shadow(radius: 2)
        }
    }
    
    // MARK: - (2) 집중도 추이 차트
    private var concentrationChart: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("집중도 추이")
                .font(.headline)
            
            Chart(viewModel.concentrationData) { data in
                // 선 그래프
                LineMark(
                    x: .value("시간", data.timestamp),
                    y: .value("집중도", data.concentrationScore)
                )
                .foregroundStyle(.blue)
                .interpolationMethod(.catmullRom) // 부드러운 곡선
                
                // 채워진 영역 그래프(하이라이트용)
                AreaMark(
                    x: .value("시간", data.timestamp),
                    y: .value("집중도", data.concentrationScore)
                )
                .foregroundStyle(.linearGradient(
                    colors: [.blue.opacity(0.3), .blue.opacity(0.1)],
                    startPoint: .top,
                    endPoint: .bottom
                ))
            }
            .frame(height: 200)
            .chartYScale(domain: 0...100)  // Y축 0-100 고정
            .chartXAxis {                  // X축: 시간
                AxisMarks(preset: .automatic) { _ in
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.hour().minute())
                }
            }
            .chartYAxis {                  // Y축: %
                AxisMarks(position: .leading) { value in
                    AxisGridLine()
                    AxisValueLabel {
                        if let intValue = value.as(Int.self) {
                            Text("\(intValue)%")
                                .font(.caption)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
    // MARK: - (3) 세부 지표 차트 모음
    private var detailChartsSection: some View {
        VStack(spacing: 16) {
            // ⓐ 깜빡임
            DetailChart(
                title: "깜빡임 횟수",
                data: viewModel.concentrationData.map { ($0.timestamp, $0.blinkRate) },
                color: .purple,
                unit: "회/분",
                idealRange: 15...20
            )
            // ⓑ 머리 움직임
            DetailChart(
                title: "머리 움직임",
                data: viewModel.concentrationData.map { ($0.timestamp, $0.headMovement) },
                color: .orange,
                unit: "%",
                idealRange: 0...20
            )
            // ⓒ 졸음 레벨
            DetailChart(
                title: "졸음 감지",
                data: viewModel.concentrationData.map { ($0.timestamp, $0.drowsinessLevel) },
                color: .red,
                unit: "%",
                idealRange: 0...10
            )
        }
    }
    
    // MARK: - 도우미 함수 (초 → “X시간 Y분” 문자열)
    private func formatTime(_ seconds: TimeInterval) -> String {
        let hours = Int(seconds) / 3600
        let minutes = (Int(seconds) % 3600) / 60
        return hours > 0 ? "\(hours)시간 \(minutes)분" : "\(minutes)분"
    }
    
    // MARK: - 평균 집중도에 따른 색상
    private func concentrationColor(_ score: Double) -> Color {
        switch score {
        case 80...100: return .green   // 우수
        case 60..<80: return .orange   // 보통
        default:       return .red     // 낮음
        }
    }
}

// MARK: - 세부 차트 공통 컴포넌트
struct DetailChart: View {
    let title: String                           // 차트 제목
    let data: [(Date, Double)]                  // (시간, 값) 배열
    let color: Color                            // 선 색상
    let unit: String                            // 단위 문자열
    let idealRange: ClosedRange<Double>?        // 이상적 범위(배경 표시용)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 헤더: 제목 + 현재값
            HStack {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Spacer()
                if let currentValue = data.last?.1 {
                    Text("\(Int(currentValue))\(unit)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // 차트 그리기
            Chart {
                // 라인 마크
                ForEach(Array(data.enumerated()), id: \.offset) { _, item in
                    LineMark(
                        x: .value("시간", item.0),
                        y: .value("값", item.1)
                    )
                    .foregroundStyle(color)
                    .interpolationMethod(.catmullRom)
                }
                // 이상적 범위(녹색 반투명)
                if let range = idealRange {
                    RectangleMark(
                        yStart: .value("시작", range.lowerBound),
                        yEnd: .value("끝", range.upperBound)
                    )
                    .foregroundStyle(Color.green.opacity(0.1))
                }
            }
            .frame(height: 100)
            .chartXAxis(.hidden)            // X축 레이블 숨김
            .chartYAxis {                   // 간결한 Y축
                AxisMarks(position: .leading, values: .automatic(desiredCount: 3)) { _ in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                    AxisValueLabel()
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}

// MARK: - 미리보기
#Preview {
    NavigationView {       // NavigationView로 감싸야 툴바가 보임
        AnalyzeView()
    }
}
