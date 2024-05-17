//
//  CoupleCalanderApp.swift
//  CoupleCalander
//
//  Created by KYUCHEOL KIM on 5/15/24.
//

import SwiftUI

@main
struct CoupleCalendarApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: DateViewModel(dataController: dataController))
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
