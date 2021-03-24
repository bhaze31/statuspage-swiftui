//
//  ContentView.swift
//  StatuspageSwiftUI
//
//  Created by Brian Hasenstab on 3/24/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var state: AppState

    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section(header: Text("Pages")) {
                        ForEach(state.pageViewModel.pages) { page in
                            Text(page.name)
                        }
                    }

                    Section(header: Text("Components")) {
                        ForEach(state.componentViewModel.components) { component in
                            Text(component.name)
                        }
                    }

                    Section(header: Text("Incidents")) {
                        ForEach(state.incidentsViewModel.incidents) { incident in
                            Text(incident.name)
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
            .onAppear {
                state.pageViewModel.fetchPages()
                state.componentViewModel.fetchComponentsForPage("1v3szkf8bfgw")
                state.incidentsViewModel.fetchIncidentsForPage("1v3szkf8bfgw")
            }
            .navigationTitle("Statuspage")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppState())
    }
}
