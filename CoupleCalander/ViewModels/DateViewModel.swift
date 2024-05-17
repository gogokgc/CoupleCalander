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
    @Published var dateCounts: [DateCount] = []
    @Published var name: String = ""
    @Published var startDate: Date = Date()
    
    private let dataController: DataController
    private var cancellables = Set<AnyCancellable>()
    
    init(dataController: DataController) {
        self.dataController = dataController
        fetchDateCounts()
    }
    
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
}

