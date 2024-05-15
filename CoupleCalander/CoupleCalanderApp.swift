//
//  CoupleCalanderApp.swift
//  CoupleCalander
//
//  Created by KYUCHEOL KIM on 5/15/24.
//

import SwiftUI

@main
struct CoupleCalanderApp: App {
    // 데이터베이스 삽입
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext) //
        }
    }
}
