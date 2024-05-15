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
