//
//  MainView.swift
//  CoupleCalander
//
//  Created by KYUCHEOL KIM on 5/15/24.
//

import SwiftUI

struct MainView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.startDate, order: .reverse)]) var dateCount: FetchedResults<DateCount>
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                if dateCount.isEmpty {
                    Text("처음 만난 날을 지정해 주세요!")
                        .padding(.bottom, 50)
                        .font(.title)
                        .bold()
                    NavigationLink("등록하기", destination: AddDateView())
                } else {
                    Text(startDateFormatting(date: dateCount[0].startDate!))
                        .padding(.bottom, 10)
                    Text(calcDateSince(date: dateCount[0].startDate!))
                        .font(.largeTitle)
                        .bold()
                }
                Spacer()
                Spacer()
            }
        }
    }
}

#Preview {
    MainView()
}
