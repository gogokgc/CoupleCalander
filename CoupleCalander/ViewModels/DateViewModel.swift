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
    @Published var startDate: Date = Date()
    
    private let dataController: DataController
    // ViewModel에서 Combine을 사용하여 비동기 데이터를 처리할 때, 구독을 취소할 수 있는 메커니즘을 제공하기 위해 선언
    private var cancellables = Set<AnyCancellable>()
    
    // ViewModel이 초기화될 때 Core Data에서 데이터를 가져오기 위해 fetchDateCounts()를 호출.
    init(dataController: DataController) {
        self.dataController = dataController
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
}

