//
//  NetworkManager.swift
//  NetworkLayer
//
//  Created by Mert Demirtaş on 16.04.2022.
//

import Foundation

public class NetworkManager {
    static let shared = NetworkManager()
    
    var networkStateClosure: ((NetworkStates) -> Void)?
    
    private init() {
    }
    
    func fetchData<T: Decodable>(endpoint: Endpoint, completionHandler: @escaping (Result<T, NetworkErrors>) -> Void) {
        
        // MARK: URL
        guard let urlString = endpoint.url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completionHandler(.failure(.clientError))
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        var urlRequest = URLRequest(url: url)
        
        // MARK: HTTP Method
        urlRequest.httpMethod = endpoint.httpMethod.rawValue
        
        if let headers = endpoint.headers {
            for element in headers {
                urlRequest.setValue(element.value, forHTTPHeaderField: element.key)
            }
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: { data, response, error in

            if let statusCode = (response as? HTTPURLResponse)?.statusCode , 200..<300 ~= statusCode {
                completionHandler(.failure(NetworkErrors(statusCode: statusCode)))
                return
            }
            guard let data = data, error == nil else {
                completionHandler(.failure(.unknown))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completionHandler(.success(decodedData))
            }
            catch {
                completionHandler(.failure(.decodeError))
            }
        })
        task.resume()
    }
}
