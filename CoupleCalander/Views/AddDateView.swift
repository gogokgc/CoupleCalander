//
//  AddDateView.swift
//  CoupleCalander
//
//  Created by KYUCHEOL KIM on 5/15/24.
//

import SwiftUI

struct AddDateView: View {
    //CoreData의 관리 객체 컨텍스트를 가져옵니다
    @Environment(\.managedObjectContext) var managedObjContext
    //화면을 닫는 데 사용되는 기능을 가져옵니다
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var startDate = Date()
    
    var body: some View {
        Form {
            Section {
                
                VStack {
                    Label(
                        title: { Text("우리 사랑의 첫 시작일") },
                        icon: { Image(systemName: "heart.fill") }
                    )
                    .padding()
                    
                    DatePicker("날짜를 선택해 주세요", selection: $startDate, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .padding()
                    Spacer()
                    HStack{
                        Button("등록") {
                            DataController().add(name: name, startDate: startDate, context: managedObjContext)
                            dismiss()
                        }
                    }
                    Spacer()
                }
                
            }
        }
    }
}

#Preview {
    AddDateView()
}
