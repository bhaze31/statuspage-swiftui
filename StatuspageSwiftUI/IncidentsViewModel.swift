//
//  IncidentsViewModel.swift
//  StatuspageSwiftUI
//
//  Created by Brian Hasenstab on 3/24/21.
//

import Foundation
import Combine

final class Incident: StatuspageAPICodable {
    var impact: String
    var components: [Component]
    var pageId: String
    var startedAt: String
    var resolvedAt: String
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        impact = try container.decode(String.self, forKey: .impact)
        components = try container.decode([Component].self, forKey: .components)
        pageId = try container.decode(String.self, forKey: .pageId)
        startedAt = try container.decode(String.self, forKey: .startedAt)
        resolvedAt = try container.decode(String.self, forKey: .resolvedAt)
        
        try super.init(from: decoder)
    }
    
    enum CodingKeys: String, CodingKey {
        case impact, components
        case pageId = "page_id"
        case startedAt = "started_at"
        case resolvedAt = "resolved_at"
    }
}

class IncidentsViewModel: APIViewModel {
    @Published var incidents: [Incident] = []
    
    func fetchIncidentsForPage(_ page: String) {
        incidents = []
        subscription?.cancel()
        
        let endpoint = Endpoint(path: "v1/pages/\(page)/incidents")
        
        subscription = network.get(url: endpoint.url, headers: defaultHeaders(), handler: handleFetchMap)
            .sink(
                receiveCompletion: handleFetchCompletion,
                receiveValue: handleFetchIncidentsReceived
            )
    }
    
    func handleFetchIncidentsReceived(incidents: [Incident]) {
        self.incidents = incidents
    }
}
