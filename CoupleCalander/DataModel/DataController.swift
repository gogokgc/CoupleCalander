//
//  DataController.swift온ㄹ
//  CoupleCalander
//
//  Created by KYUCHEOL KIM on 5/15/24.
//

import Foundation
import CoreData

/// 데이터 베이스 데이터 관리 설정 및 메소드 정리 PersistentController
class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "DateModel")
    
    init() {
        container.loadPersistentStores { desc, error in
            if let error = error {
                print("Failed to load Data \(error.localizedDescription)")
            }
        }
    }
    
    func save() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("Data saved successfully!!!")
            } catch {
                // Handle errors in our database
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
       
    }
    
    func add(name: String, startDate: Date, context: NSManagedObjectContext) {
        let dateCount = DateCount(context: context)
        dateCount.name = name
        dateCount.startDate = startDate
        
        save()
    }
    
    func edit(dateCount: DateCount, name: String, editDate: Date, context: NSManagedObjectContext) {
        dateCount.name = name
        dateCount.startDate = editDate
        
        save()
    }
}
