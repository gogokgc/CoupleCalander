//
//  ContentView.swift
//  CoupleCalander
//
//  Created by KYUCHEOL KIM on 5/15/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: DateViewModel
    
    init(viewModel: DateViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                TabView {
                    MainView(viewModel: viewModel)
                        .tabItem {
                            Image(systemName: "heart")
                        }
                    Text("Tab Content 2")
                    //TODO: 기념일 리스트 추가
                    DaylistView(viewModel: viewModel)
                        .tabItem {
                            Image(systemName: "clipboard.fill")
                        }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if !viewModel.dateCounts.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            EditDateView(viewModel: viewModel, dateCount: viewModel.dateCounts[0])
                        } label: {
                            Label("수정", systemImage: "pencil.circle")
                        }
                    }
                }
                // TODO: 전체 메뉴버튼 추가
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
    @ObservedObject var viewModel: DateViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                if viewModel.dateCounts.isEmpty {
                    Text("처음 만난 날을 지정해 주세요!")
                        .padding(.bottom, 50)
                        .font(.title)
                        .bold()
                    NavigationLink("등록하기", destination: AddDateView(viewModel: viewModel))
                } else {
                    let dateCount = viewModel.dateCounts[0]
                    Text(startDateFormatting(date: dateCount.startDate!))
                        .padding(.bottom, 10)
                    Text(calcDateSince(date: dateCount.startDate!))
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
    @ObservedObject var viewModel: DateViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            Section {
                VStack {
                    Label(
                        title: { Text("우리 사랑의 첫 시작일") },
                        icon: { Image(systemName: "heart.fill") }
                    )
                    .padding()
                    
                    DatePicker("날짜를 선택해 주세요", selection: $viewModel.startDate, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .padding()
                    Spacer()
                    HStack {
                        Button("등록") {
                            viewModel.addDateCount()
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
    @ObservedObject var viewModel: DateViewModel
    @Environment(\.dismiss) var dismiss
    
    var dateCount: DateCount
    
    var body: some View {
        Form {
            Section {
                VStack {
                    Label(
                        title: { Text("우리 사랑의 첫 시작일") },
                        icon: { Image(systemName: "heart.fill") }
                    )
                    .padding()
                    
                    DatePicker("날짜를 선택해 주세요", selection: $viewModel.startDate, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .padding()
                    Spacer()
                    HStack {
                        Button("수정") {
                            viewModel.editDateCount(dateCount: dateCount)
                            dismiss()
                        }
                    }
                    Spacer()
                }
            }
        }
    }
}

struct DaylistView: View {
    @ObservedObject var viewModel: DateViewModel
    
    var body: some View {
        VStack {
            
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let dataController = DataController()
        let viewModel = DateViewModel(dataController: dataController)
        ContentView(viewModel: viewModel)
    }
}
