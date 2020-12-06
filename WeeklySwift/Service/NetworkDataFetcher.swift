//
//  NetworkDataFetcher.swift
//  WeeklySwift
//
//  Created by Viachaslau on 12/5/20.
//

import Foundation

class NetworkDataFetcher {
    var networkService = NetworkService()
    
    func fetchImages(searchTerm: String, complition: @escaping (SearchResults?) -> Void) {
        networkService.request(searchTerm: searchTerm) { data, error in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                complition(nil)
            }
            
            let decode = self.decodeJSON(type: SearchResults.self, from: data)
            complition(decode)
        }
    }
    
    func decodeJSON<T: Decodable>(type: T.Type, from data: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = data else {
            return nil
        }
        
        do {
            let object = try decoder.decode(type.self, from: data)
            return object
        } catch let jsonError {
            print("Failed to decode JSON:", jsonError)
            return nil
        }
    }
}
