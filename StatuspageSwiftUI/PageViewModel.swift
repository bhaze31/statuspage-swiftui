//
//  PageViewModel.swift
//  StatuspageSwiftUI
//
//  Created by Brian Hasenstab on 3/24/21.
//

import Foundation
import Combine


final class Page: StatuspageAPICodable {
    var subdomain: String
    var pageDescription: String
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        subdomain = try container.decode(String.self, forKey: .subdomain)
        pageDescription = try container.decodeIfPresent(String.self, forKey: .subdomain) ?? ""
        
        try super.init(from: decoder)
    }

    enum CodingKeys: String, CodingKey {
        case subdomain
        case pageDescription = "page_description"
    }
}

final class PageViewModel: APIViewModel {
    @Published var pages: [Page] = []
    
    func fetchPages() {
        let endpoint = Endpoint(path: "v1/pages")
        
        network.get(url: endpoint.url, headers: defaultHeaders(), handler: handleFetchMap)
            .sink(receiveCompletion: handleFetchCompletion, receiveValue: handleFetchPagesReceived)
            .store(in: &subscriptions)
    }
    
    func handleFetchPagesReceived(pages: [Page]) {
        self.pages = pages
    }
}
