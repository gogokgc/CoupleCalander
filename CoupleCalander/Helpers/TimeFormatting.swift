//
//  TimeFormatting.swift
//  CoupleCalander
//
//  Created by KYUCHEOL KIM on 5/15/24.
//

import Foundation

func calcDateSince(date: Date) -> String {
    let now = Date()
    let intervalInSeconds = -date.timeIntervalSince(now)
    let intervalInDays = intervalInSeconds / (60 * 60 * 24) // 시간 간격을 일(day)로 변환
    
    return "\(String(format: "%.0f", intervalInDays)) 일째 사랑중"
}

func startDateFormatting(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    
    return formatter.string(from: date)
}

func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    
    return formatter.string(from: date)
}

func calculateDates(from startDate: Date, intervals: [Int]) -> [Date] {
    let calendar = Calendar.current
    var dates: [Date] = []

    // Add interval dates
    for interval in intervals {
        if let date = calendar.date(byAdding: .day, value: interval, to: startDate) {
            dates.append(date)
        }
    }

    // Sort dates
    dates.sort()
    return dates
}

func createDate(month: Int, day: Int) -> Date {
    let calendar = Calendar.current
    var components = DateComponents()
    components.year = calendar.component(.year, from: Date())
    components.month = month
    components.day = day
    return calendar.date(from: components) ?? Date()
}
