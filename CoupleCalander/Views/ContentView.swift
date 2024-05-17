//
//  ContentView.swift
//  CoupleCalander
//
//  Created by KYUCHEOL KIM on 5/15/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \DateCount.startDate, ascending: true)],
        animation: .default)
    private var dateCount: FetchedResults<DateCount>
    
    @State private var showingEditView = false
    
    var body: some View {
        NavigationStack{
            ZStack {
                TabView(
                    selection: .constant(1),
                    content:  {
                        MainView()
                            .tabItem {
                                Image(systemName: "heart")
                            }
                            .tag(1)
                        Text("Tab Content 2")
                            .tabItem {
                                Image(systemName: "clipboard.fill")
                            }
                            .tag(2)
                    }
                )
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if !dateCount.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            EditDateView(dateCount: dateCount[0])
                        } label: {
                            Label("수정", systemImage: "pencil.circle")
                        }
                    }
                }
                //TODO: 전체 메뉴버튼 추가
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        
                    } label: {
                        Label("수정", systemImage: "menucard")
                    }
                }
            }
        }
    }
}

//MARK: 일수 표현 뷰
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

//MARK: 날짜 등록뷰
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

//MARK: 날짜 수정뷰
struct EditDateView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    //엔티티의 특정 인스턴스를 편집
    var dateCount: FetchedResults<DateCount>.Element
    
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

#Preview {
    ContentView()
}
