//
//  DateViewModel.swift
//  CoupleCalander
//
//  Created by KYUCHEOL KIM on 5/17/24.
//

import Foundation
import CoreData
import Combine

class DateViewModel: ObservableObject {
    // Published 프로퍼티는 변경 시 뷰를 업데이트하도록 해줌
    @Published var dateCounts: [DateCount] = [] // Core Data에서 불러온 DateCount 객체를 저장.
    @Published var name: String = ""
    @Published var startDate: Date
    
    private let dataController: DataController
    // ViewModel에서 Combine을 사용하여 비동기 데이터를 처리할 때, 구독을 취소할 수 있는 메커니즘을 제공하기 위해 선언
    private var cancellables = Set<AnyCancellable>()
    
    @Published var calculatedDates: [(String, Date)] = []
    var todayIndex: Int? = nil
    let intervals: [Int]
    
    // ViewModel이 초기화될 때 Core Data에서 데이터를 가져오기 위해 fetchDateCounts()를 호출.
    init(dataController: DataController, startDate: Date, intervals: [Int] = Array(stride(from: 100, through: 10000, by: 100))) {
        self.dataController = dataController
        self.startDate = startDate
        self.intervals = intervals
        self.calculatedDates = calculateDates(from: startDate)
        fetchDateCounts()
    }
    
    // Core Data에서 DateCount 객체들을 불러와 dateCounts에 저장. 데이터 정렬을 위해 sortDescriptors를 사용.
    func fetchDateCounts() {
        let request: NSFetchRequest<DateCount> = DateCount.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \DateCount.startDate, ascending: true)]
        
        do {
            let results = try dataController.container.viewContext.fetch(request)
            self.dateCounts = results
        } catch {
            print("Failed to fetch DateCounts: \(error.localizedDescription)")
        }
    }
    
    func addDateCount() {
        dataController.add(name: name, startDate: startDate, context: dataController.container.viewContext)
        fetchDateCounts()
    }
    
    func editDateCount(dateCount: DateCount) {
        dataController.edit(dateCount: dateCount, name: name, editDate: startDate, context: dataController.container.viewContext)
        fetchDateCounts()
    }
    
    func calcDateSince(date: Date) -> String {
        let now = Date()
        let intervalInSeconds = -date.timeIntervalSince(now)
        let intervalInDays = intervalInSeconds / (60 * 60 * 24) // 시간 간격을 일(day)로 변환
        
        return "\(String(format: "%.0f", intervalInDays))"
    }

    func startDateFormatting(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        
        return formatter.string(from: date)
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd (E)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }

    func calculateDates(from startDate: Date) -> [(String, Date)] {
        let calendar = Calendar.current
        var dates: [(String, Date)] = []

        // Add interval dates
//        for interval in intervals {
//            if let date = calendar.date(byAdding: .day, value: interval, to: startDate) {
//                dates.append(date)
//            }
//        }
        // Add interval dates (100 days increments)
        for interval in intervals {
            if let date = calendar.date(byAdding: .day, value: interval, to: startDate) {
                dates.append(("\(interval)일", date))
            }
        }
        

        // Add today's date
        dates.append(("\(calcDateSince(date: startDate))일", Date()))
        
        // Sort dates
        dates.sort { $0.1 < $1.1 }
        
        // Set todayIndex
        if let index = dates.firstIndex(where: { calendar.isDate($0.1, inSameDayAs: Date()) }) {
            self.todayIndex = index
        }
        
        return dates
    }

    func calculateDDay(_ date: Date) -> String {
        let today = Calendar.current.startOfDay(for: Date())
        let targetDay = Calendar.current.startOfDay(for: date)
        let components = Calendar.current.dateComponents([.day], from: today, to: targetDay)
        
        guard let daysLeft = components.day else { return "" }
        
        if daysLeft == 0 {
            return "오늘"
        } else if daysLeft > 0 {
            return "D-\(daysLeft)"
        } else {
            return "\(-daysLeft) 일전"
        }
    }
    
    func isPastDate(_ date: Date) -> Bool {
        let today = Calendar.current.startOfDay(for: Date())
        let targetDay = Calendar.current.startOfDay(for: date)
        return targetDay < today
    }
    
    func isToday(_ date: Date) -> Bool {
        let today = Calendar.current.startOfDay(for: Date())
        return Calendar.current.isDate(date, inSameDayAs: today)
    }

    func createDate(month: Int, day: Int) -> Date {
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = calendar.component(.year, from: Date())
        components.month = month
        components.day = day
        return calendar.date(from: components) ?? Date()
    }
}

