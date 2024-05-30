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
                    DaylistView(startDate: viewModel.startDate)
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
    //    @ObservedObject var viewModel: DateViewModel
    let startDate: Date
    let intervals: [Int] = Array(stride(from: 100, through: 10000, by: 100))
    @State private var calculatedDates: [Date] = []
    
    var body: some View {
        ScrollView {
            Text("기념일")
            VStack(spacing: 5) {
                ForEach(Array(calculatedDates.enumerated()), id: \.offset) { index, date in
                    HStack{
                        if index < intervals.count {
                            Text("\(intervals[index])일 \(Image(systemName: "heart.fill"))")
                        }
                        Spacer()
                        Text(formattedDate(date))
                            .padding()
                            .cornerRadius(8)
                        Spacer()
                    }
                }
            }
            .padding()
        }
        .onAppear {
            calculatedDates = calculateDates(from: startDate, intervals: intervals)
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
