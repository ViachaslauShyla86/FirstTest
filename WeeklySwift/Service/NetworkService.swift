//
//  NetworkService.swift
//  WeeklySwift
//
//  Created by Viachaslau on 12/5/20.
//

import UIKit

class NetworkService {
    func request(searchTerm: String, complition: @escaping (Data?, Error?) -> Void) {
        let param = prepareParametrs(searchTerm: searchTerm)
        let url = self.url(params: param)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = prepareHeaders()
        request.httpMethod = "get"
        let task = createDataTask(from: request, complition: complition)
        task.resume()
    }
    
    private func prepareHeaders() -> [String: String]? {
        var headers = [String: String]()
        headers["Authorization"] = "Client-ID x844eHTZI0Pjd0s1aVeKQpaKB5RQtAGkdeVJhBEGvUc"
        return headers
    }
    
    private func prepareParametrs(searchTerm: String) -> [String: String] {
        var param = [String: String]()
        param["query"] = searchTerm
        param["page"] = String(1)
        param["per_page"] = String(30)
        
        return param
    }
    
    private func url(params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/search/photos" // после host и до ? - это path (https://api.unsplash.com/search/collections?page=1&query=office>)
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        
        return components.url!
    }
    
    private func createDataTask(from request: URLRequest, complition: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                complition(data, error)
            }
        }
    }
}

