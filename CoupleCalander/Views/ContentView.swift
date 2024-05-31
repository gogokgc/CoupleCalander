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
                    DaylistView(viewModel: viewModel, startDate: viewModel.dateCounts[0].startDate ?? Date())
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
                        Label("메뉴", systemImage: "menucard")
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
                    Text(viewModel.startDateFormatting(date: dateCount.startDate!))
                        .padding(.bottom, 10)
                    Text("\(viewModel.calcDateSince(date: dateCount.startDate!)) 일째 사랑중")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                    HStack {
                        Spacer()
                        VStack {
                            Image(systemName: "person")
                            Text("birthday")
                        }
                        Spacer()
                        Image(systemName: "heart.fill")
                        Spacer()
                        VStack {
                            Image(systemName: "person")
                            Text("birthday")
                        }
                        Spacer()
                    }
                }
                Spacer()
                Spacer()
            }
            .background(
                Image("background1")
                    .resizable()
                    .scaledToFill()
                    .blur(radius: 2) // 흐림 효과 추가
//                    .edgesIgnoringSafeArea(.all) // 이미지가 안전 영역을 무시하고 전체 화면을 채우도록 설정
            )
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
    let startDate: Date
    @State private var calculatedDates: [(String, Date)] = []
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                Text("기념일")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 20)
                VStack(spacing: 20) {
                    ForEach(Array(calculatedDates.enumerated()), id: \.offset) { index, date in
                        HStack {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(date.0)
                                        .font(.headline)
                                        .foregroundColor(viewModel.isToday(date.1) ? .red : (index % 2 == 0 ? .pink : .blue))
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(index % 2 == 0 ? .pink : .blue)
                                }
                                Text(viewModel.formattedDate(date.1))
                                    .font(.system(size: 12))
                            }
                            Spacer()
                            Spacer()
                            Text(viewModel.calculateDDay(date.1))
                                .font(.footnote)
                                .foregroundColor(viewModel.isPastDate(date.1) ? .gray : .pink)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                        .background(viewModel.todayIndex == index ? Color(UIColor.systemPink).opacity(0.1) : Color.clear)
                        .cornerRadius(10)
                        .id(index)
                    }
                }
                .padding()
                .onAppear {
                    calculatedDates = viewModel.calculateDates(from: startDate)
                    if let todayIndex = viewModel.todayIndex {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            proxy.scrollTo(todayIndex, anchor: .center)
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let dataController = DataController()
        let viewModel = DateViewModel(dataController: dataController, startDate: Date())
        ContentView(viewModel: viewModel)
    }
}
