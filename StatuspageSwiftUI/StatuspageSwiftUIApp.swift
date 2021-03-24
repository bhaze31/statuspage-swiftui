//
//  StatuspageSwiftUIApp.swift
//  StatuspageSwiftUI
//
//  Created by Brian Hasenstab on 3/24/21.
//

import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var pageViewModel = PageViewModel()
    @Published var componentViewModel = ComponentViewModel()
    @Published var incidentsViewModel = IncidentsViewModel()
    
    private var subscriptions: Set<AnyCancellable> = []
    
    init() {
        pageViewModel.objectWillChange
            .sink(receiveValue: { self.objectWillChange.send() })
            .store(in: &subscriptions)
        componentViewModel.objectWillChange
            .sink(receiveValue: { self.objectWillChange.send() })
            .store(in: &subscriptions)
        incidentsViewModel.objectWillChange
            .sink(receiveValue: { self.objectWillChange.send() })
            .store(in: &subscriptions)
    }
}

@main
struct StatuspageSwiftUIApp: App {
    @StateObject var state = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(state)
        }
    }
}
