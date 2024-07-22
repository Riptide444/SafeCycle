//
//  SearchView.swift
//  SafeCycle
//
//  Created by Daniel Skendaj on 7/23/24.
//

import SwiftUI

struct SearchView: View {
    @Binding var isDisabled: Bool
    @ObservedObject var searchManager: SearchManager
    @ObservedObject var locationManager: LocationManager
    let searchNamespace: Namespace.ID
    @State private var searchQuery = ""
    @State private var debounceTimer: Timer? = nil
    
    var body: some View {
        ZStack(alignment: .top) {
            MapView(locationManager: locationManager, navigationManager: NavigationManager())
            Rectangle()
                .fill(.thinMaterial)
                .ignoresSafeArea()
            Rectangle()
                .fill(.black.opacity(0.3))
                .ignoresSafeArea()
            VStack {
                SearchButtonView(searchPrompt: $searchQuery, isDisabled: $isDisabled)
                    .matchedGeometryEffect(id: "search", in: searchNamespace)
                    .onChange(of: searchQuery) {
                        debounceTimer?.invalidate()
                        debounceTimer = Timer.scheduledTimer(withTimeInterval: 1.3, repeats: false) { _ in
                            
                            if !searchQuery.isEmpty {
                                searchManager.search(query: searchQuery)
                            } else {
                                searchManager.searchResults = []
                            }
                        }
                    }
                    .padding(.bottom)
                
                ScrollView {
                    ForEach(searchManager.searchResults) { result in
                        Button(action: {
                            locationManager.updateDestination(newDestination: result)
                            searchManager.hideSearchView()
                        }, label: {
                            SearchResultView(name: result.name, address: result.address)
                                    .padding(.bottom, 6)
                        })
                        .buttonStyle(PlainButtonStyle())
                        
                    }
                }
                .ignoresSafeArea(edges: .bottom)
            }
            .padding()
        }
    }
}

//#Preview {
//    SearchView(searchNamespace: namespace)
//}
