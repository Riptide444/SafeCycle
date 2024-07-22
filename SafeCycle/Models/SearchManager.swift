//
//  SearchResults.swift
//  SafeCycle
//
//  Created by Daniel Skendaj on 7/29/24.
//

import Foundation
import MapKit
import SwiftUI

struct SearchResult: Identifiable, Equatable {
    static func == (lhs: SearchResult, rhs: SearchResult) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id = UUID()
    let name: String
    let address: String
    let coordinate: CLLocationCoordinate2D
}

extension String {
    var isNumber: Bool {
        let digitsCharacters = CharacterSet(charactersIn: "0123456789")
        return CharacterSet(charactersIn: self).isSubset(of: digitsCharacters)
    }
}

class SearchManager: ObservableObject {
    @Published var searchResults: [SearchResult] = []
    @Published var isSearchDisplayed: Bool = false
    
    private var searchRequest: MKLocalSearch.Request
    
    init() {
        searchRequest = MKLocalSearch.Request()
        searchRequest.resultTypes = .pointOfInterest
    }
    
    func showSearchView() {
        isSearchDisplayed = true
    }
    
    func hideSearchView() {
        isSearchDisplayed = false
    }
    
    func search(query: String) {
        if query != "" {
            if query.first!.isNumber {
                searchRequest.resultTypes = .address
            } else {
                searchRequest.resultTypes = .pointOfInterest
            }
            searchRequest.naturalLanguageQuery = query
            let search = MKLocalSearch(request: searchRequest)
            search.start { response, error in
                guard let response = response else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                self.searchResults = response.mapItems.compactMap { item in
                    guard let name = item.name,
                          let coordinate = item.placemark.location?.coordinate,
                          let address = item.placemark.title else { return nil }
                    return SearchResult(name: name, address: address, coordinate: coordinate)
                }
            }
        }
    }
}



