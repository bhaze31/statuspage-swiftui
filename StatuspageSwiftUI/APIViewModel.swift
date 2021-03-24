//
//  APIViewModel.swift
//  StatuspageSwiftUI
//
//  Created by Brian Hasenstab on 3/24/21.
//

import Foundation
import Combine

class StatuspageAPICodable: Codable, Identifiable {
    var id: String
    var name: String
    var createdAt: String
    var updatedAt: String
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        updatedAt = try container.decode(String.self, forKey: .updatedAt)
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

class APIViewModel: ObservableObject {
    let network = NetworkController()
    
    var subscriptions: Set<AnyCancellable> = []
    var subscription: AnyCancellable?

    func handleFetchMap(data: Data, _response: URLResponse) throws -> Data {
        // Check response code, etc, throw any errors
        guard let response = _response as? HTTPURLResponse else {
            throw NetworkError.Unknown
        }
        
        if response.statusCode >= 400 {
            switch response.statusCode {
                case 401:
                    throw NetworkError.NotAllowed
                default:
                    throw NetworkError.Unknown
            }
        }

        return data
    }
    
    func handleFetchCompletion(complete: Subscribers.Completion<Error>) {
        switch complete {
            case .failure(let e):
                print("[XX] Failed to complete request: \(e)")
            case .finished:
                print("[!!] API Request Completed")
                
        }
    }
}
