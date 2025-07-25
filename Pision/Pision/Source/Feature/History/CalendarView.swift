//
//  CalendarView.swift
//  Pision
//
//  Created by YONGWON SEO on 7/22/25.
//

import SwiftUI

// MARK: - Var
struct CalendarView: View {
  struct DateItem: Identifiable {
    let id = UUID()
    let date: Date
    let weekday: String
    let day: Int
  }
  
  @Binding var selectedDate: Date
  @Binding var selectedMode: ViewMode  
  
  private let itemWidth: CGFloat = 40
  private let itemHeight: CGFloat = 60
  private let visibleCount: Int = 7
  private let spacingCount = 6
  
  @State private var scrollOffset: CGFloat = 0
  @State private var draggingOffset: CGFloat = 0
  @State private var selectedIndex: Int = 0
  
  @State private var currentScrolledMonth: Date = Date()
  
  
  @State private var monthOffsets: [Int] = [0]
  @State private var baseDate: Date = Date()
  @State private var isAppending: Bool = false
  
  private let dates: [DateItem]
  
  init(selectedDate:Binding<Date>, selectedMode: Binding<ViewMode>) {
    self._selectedDate = selectedDate
    self._selectedMode = selectedMode
    var temp: [DateItem] = []
    let calendar = Calendar.current
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "E"
    
    for offset in -100...100 {
      let date = calendar.date(byAdding: .day, value: offset, to: Date())!
      temp.append(DateItem(
        date: date,
        weekday: formatter.string(from: date),
        day: calendar.component(.day, from: date)
      ))
    }
    dates = temp
  }
}

// MARK: - View
extension CalendarView {
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 16)
        .fill(Color.white)
      VStack{
        HStack{
          Text(monthYearString(from: currentScrolledMonth))
            .font(.FontSystem.h2)
            .padding(.leading, 10)
            .padding(.top, 10)
          Spacer()
          modePicker()
        }
        .padding(.horizontal)
        .padding(.top)
        
        GeometryReader { geo in
          Group {
            if selectedMode == .daily {
              dailyScrollView(geo: geo)
                .frame(height: 40)
            } else {
              monthlyGridView()
                .frame(height: 320)
            }
          }
        }
        .padding(.horizontal)
      }
    }
    .padding(.horizontal)
  }
}

// MARK: - Func
extension CalendarView {
  
  func currentMonthString() -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US")
    formatter.dateFormat = "MMM"
    return formatter.string(from: Date())
  }
  
  func spacing(in width: CGFloat) -> CGFloat {
    (width - CGFloat(visibleCount) * itemWidth) / CGFloat(spacingCount)
  }
  
  func totalContentWidth(in width: CGFloat) -> CGFloat {
    CGFloat(visibleCount) * itemWidth + CGFloat(spacingCount) * spacing(in: width)
  }
  
  func makeFormatter() -> DateFormatter {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US")
    formatter.dateFormat = "E"
    return formatter
  }
  
  func monthYearString(from date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "MMM yyyy"
    return formatter.string(from: date)
  }
  
  enum ViewMode: String {
    case daily = "주"
    case monthly = "월"
  }
  
  // PreferenceKey 정의
  struct MonthOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: [Int: CGFloat] = [:]
    static func reduce(value: inout [Int: CGFloat], nextValue: () -> [Int: CGFloat]) {
      value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
  }
  
  @ViewBuilder
  func modePicker() -> some View {
    Menu {
      Button{
        selectedMode = .daily
      }label:{
        Text("주")
          .font(.FontSystem.h4)
          .foregroundStyle(.B_00)
      }
      Button{
        selectedMode = .monthly
      }label:{
        Text("월")
          .font(.FontSystem.h4)
          .foregroundStyle(.B_00)
      }
    } label: {
      HStack {
        Text(selectedMode.rawValue)
          .font(.FontSystem.h4)
          .foregroundStyle(.B_00)
        Image(systemName: "chevron.down")
          .font(.FontSystem.h4)
          .foregroundStyle(.B_00)
      }
      .font(.subheadline)
    }
  }
  
  @ViewBuilder
  func dailyScrollView(geo: GeometryProxy) -> some View {
    let center = geo.size.width / 2
    
    ZStack {
      RoundedRectangle(cornerRadius: 9)
        .fill(.BR_00)
        .frame(width: itemWidth, height: 50)
        .position(x: center, y: itemHeight / 2)
        .zIndex(1)
      
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 0) {
          Spacer(minLength: 0)
          
          ForEach(dates.indices, id:\.self) { i in
            let offset = CGFloat(i) * (itemWidth + spacing(in: geo.size.width))
            let itemCenter = offset + draggingOffset - scrollOffset + itemWidth / 2
            let isSelected = abs(itemCenter - center) < (itemWidth + spacing(in: geo.size.width)) / 2
            
            VStack(spacing: 4) {
              Text(dates[i].weekday)
                .font(.FontSystem.btn)
                .foregroundColor(isSelected ? .white : .BR_40)
              Text("\(dates[i].day)")
                .font(.FontSystem.btn)
                .foregroundColor(isSelected ? .white : .black)
            }
            .frame(width: itemWidth, height: itemHeight)
            .contentShape(Rectangle())
            .onTapGesture {
              withAnimation {
                selectedDate = Calendar.current.date(byAdding: .hour, value: 9, to: Calendar.current.startOfDay(for: dates[i].date))!
                
                selectedIndex = i
                
                
                scrollOffset = CGFloat(i) * (itemWidth + spacing(in: geo.size.width)) - center + itemWidth / 2
                
                
                currentScrolledMonth = Calendar.current.date(
                  from: Calendar.current.dateComponents([.year, .month], from: selectedDate)
                )!
              }
            }
            
            if i != dates.count - 1 {
              Spacer(minLength: spacing(in: geo.size.width))
            }
          }
          
          Spacer(minLength: 0)
        }
        .padding(.horizontal, (geo.size.width - totalContentWidth(in: geo.size.width)) / 2)
        .offset(x: -scrollOffset + draggingOffset)
        .gesture(
          DragGesture()
            .onChanged { value in
              draggingOffset = value.translation.width
            }
            .onEnded { value in
              let spacingValue = spacing(in: geo.size.width)
              let totalItemWidth = itemWidth + spacingValue
              let predictedOffset = scrollOffset - value.predictedEndTranslation.width
              let rawIndex = (predictedOffset + center - itemWidth / 2) / totalItemWidth
              let newIndex = max(0, min(dates.count - 1, Int(round(rawIndex))))
              
              withAnimation(.easeOut(duration: 0.3)) {
                selectedIndex = newIndex
                scrollOffset = CGFloat(newIndex) * totalItemWidth - center + itemWidth / 2
                draggingOffset = 0
                
                let newSelectedDate = Calendar.current.date(byAdding: .hour, value: 9, to: Calendar.current.startOfDay(for: dates[newIndex].date))!
                selectedDate = newSelectedDate
                
                currentScrolledMonth = Calendar.current.date(
                  from: Calendar.current.dateComponents([.year, .month], from: newSelectedDate)
                )!
              }
            }
        )
      }
      .zIndex(2)
    }
    .frame(height: itemHeight)
    .onAppear {
      if let index = dates.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }) {
        selectedIndex = index
        scrollOffset = CGFloat(index) * (itemWidth + spacing(in: geo.size.width)) - center + itemWidth / 2
      }
    }
  }
  
  @ViewBuilder
  func monthlyGridView() -> some View {
    GeometryReader { geo in
      let spacingValue = spacing(in: geo.size.width)
      let columns = Array(repeating: GridItem(.fixed(itemWidth), spacing: spacingValue), count: 7)
      let calendar = Calendar.current
      
      ScrollViewReader { scrollProxy in
        ScrollView {
          LazyVStack(spacing: 32) {
            ForEach(monthOffsets.sorted(by: >), id: \.self) { offset in
              let refDate = calendar.date(byAdding: .month, value: offset, to: baseDate) ?? baseDate
              let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: refDate))!
              let formatter = makeFormatter()
              
              let range = calendar.range(of: .day, in: .month, for: startOfMonth)!
              let numberOfDaysInMonth = range.count
              
              let firstWeekday = calendar.component(.weekday, from: startOfMonth)
              let leadingEmpty = (firstWeekday + 5) % 7
              
              let totalItems = numberOfDaysInMonth + leadingEmpty
              let rowCount = Int(ceil(Double(totalItems) / 7.0))
              let count = rowCount * 7
              
              let allDates: [DateItem] = (0..<count).compactMap { i in
                guard let date = calendar.date(byAdding: .day, value: i - leadingEmpty, to: startOfMonth) else { return nil }
                return DateItem(
                  date: date,
                  weekday: formatter.string(from: date),
                  day: calendar.component(.day, from: date)
                )
              }
              
              VStack(spacing: 12) {
                HStack(spacing: spacingValue) {
                  ForEach(["월", "화", "수", "목", "금", "토", "일"], id: \.self) { day in
                    Text(day)
                      .font(.FontSystem.btn)
                      .foregroundColor(.B_10)
                      .frame(width: itemWidth)
                  }
                }
                
                LazyVGrid(columns: columns, spacing: 5) {
                  ForEach(allDates) { item in
                    let isSelected = Calendar.current.isDate(item.date, inSameDayAs: selectedDate)
                    let isToday = Calendar.current.isDateInToday(item.date)
                    let isCurrentMonth = calendar.component(.month, from: item.date) == calendar.component(.month, from: refDate)
                    
                    Text("\(item.day)")
                      .font(.FontSystem.btn)
                      .bold()
                      .frame(width: itemWidth, height: itemWidth)
                      .background(
                        ZStack {
                          if isSelected {
                            RoundedRectangle(cornerRadius: 8).fill(Color.BR_00)
                              .frame(width:30, height:30)
                          } else if isToday {
                            Circle().fill(Color.red)
                              .frame(width:30, height:30)
                          }
                        }
                      )
                      .foregroundColor(
                        isSelected || isToday ? .white : (isCurrentMonth ? .primary : .gray)
                      )
                      .onTapGesture {
                        let adjustedDate = Calendar.current.startOfDay(for: item.date).addingTimeInterval(60 * 60 * 9)
                        selectedDate = adjustedDate
                        
                        if let index = dates.firstIndex(where: {
                          Calendar.current.isDate($0.date, inSameDayAs: adjustedDate)
                        }) {
                          selectedIndex = index
                        }
                      }
                  }
                }
              }
              .background(
                GeometryReader { _ in
                  Color.clear
                    .onAppear {
                      if offset == monthOffsets.first, !isAppending {
                        isAppending = true
                        let prepend = ((offset - 4)..<offset)
                        DispatchQueue.main.async {
                          monthOffsets.insert(contentsOf: prepend, at: 0)
                          isAppending = false
                        }
                      }
                    }
                }
              )
              .id(offset)
              
              .overlay(
                GeometryReader { geo -> Color in
                  let minY = geo.frame(in: .named("MonthlyScroll")).minY
                  DispatchQueue.main.async {
                    if minY > 0 && minY < 150 {
                      currentScrolledMonth = refDate
                    }
                  }
                  return Color.clear
                }
              )
            }
            .animation(nil, value: monthOffsets)
            
          }
          .padding(.top, 8)
        }
        .coordinateSpace(name: "MonthlyScroll")
      }
    }
  }
}

#Preview {
  CalendarView(selectedDate: .constant(Date()), selectedMode:.constant(.daily))
}
