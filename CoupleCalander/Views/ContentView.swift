//
//  ContentView.swift
//  CoupleCalander
//
//  Created by KYUCHEOL KIM on 5/15/24.
//

import SwiftUI
import CoreData

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

#Preview {
    ContentView()
}
