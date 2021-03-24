//
//  ComponentsViewModel.swift
//  StatuspageSwiftUI
//
//  Created by Brian Hasenstab on 3/24/21.
//

import Foundation
import Combine

final class Component: StatuspageAPICodable {
    var desc: String
    var pageId: String
    var position: Int
    var status: String
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        desc = try container.decodeIfPresent(String.self, forKey: .desc) ?? ""
        position = try container.decode(Int.self, forKey: .position)
        status = try container.decode(String.self, forKey: .status)
        pageId = try container.decode(String.self, forKey: .pageId)
        
        try super.init(from: decoder)
    }
    
    enum CodingKeys: String, CodingKey {
        case position, status
        case desc = "description"
        case pageId = "page_id"
    }
}

final class ComponentViewModel: APIViewModel {
    @Published var components: [Component] = []

    func fetchComponentsForPage(_ page: String) {
        components = []
        subscription?.cancel()
        
        let endpoint = Endpoint(path: "v1/pages/\(page)/components")
        
        subscription = network.get(url: endpoint.url, headers: defaultHeaders(), handler: handleFetchMap)
            .sink(
                receiveCompletion: handleFetchCompletion,
                receiveValue: handleFetchComponentsReceived
            )
    }
    
    func handleFetchComponentsReceived(components: [Component]) {
        self.components = components
    }
}

