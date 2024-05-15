//
//  EditDateView.swift
//  CoupleCalander
//
//  Created by KYUCHEOL KIM on 5/15/24.
//

import SwiftUI

struct EditDateView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    //엔티티의 특정 인스턴스를 편집
    var dateCount: FetchedResults<DateCount>.Element
//    var dateCount: [DateCount]
    
    @State private var name = ""
    @State private var editDate = Date()
    
    var body: some View {
        Form {
            Section {
                VStack {
                    Label(
                        title: { Text("우리 사랑의 첫 시작일") },
                        icon: { Image(systemName: "heart.fill") }
                    )
                    .padding()
                    
                    DatePicker("날짜를 선택해 주세요", selection: $editDate, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .padding()
                    Spacer()
                    HStack{
                        Button("수정") {
                            DataController().edit(dateCount: dateCount, name: name, editDate: editDate, context: managedObjContext)
                            dismiss()
                        }
                    }
                    Spacer()
                }
            }
        }
    }
}

//#Preview {
//    EditDateView()
//}
