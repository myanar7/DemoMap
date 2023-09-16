//
//  Service.swift
//  DemoMap
//
//  Created by Mustafa Yanar on 13.09.2023.
//

import Foundation

class Service {
    
    enum HTTPMethod: String {
        case GET = "GET"
        case POST = "POST"
    }
    
    private let session = URLSession.shared
    
    internal func request<T:Decodable>(endpoint: String, method: String, completion: @escaping (Result<T,Error>) -> Void) {
        guard let url = URL(string: endpoint) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        session.dataTask(with: urlRequest,completionHandler: { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                print(error.localizedDescription)
            } else if let response = response as? HTTPURLResponse, 200 ... 299  ~= response.statusCode {
                do {
                    guard let data else { return }
                    let stations = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(stations))
                } catch {
                    completion(.failure(error))
                }
            }
        }).resume()
    }
}
