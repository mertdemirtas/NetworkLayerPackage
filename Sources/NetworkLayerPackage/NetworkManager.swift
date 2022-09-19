//
//  NetworkManager.swift
//  NetworkLayer
//
//  Created by Mert Demirtaş on 16.04.2022.
//

import Foundation

open class NetworkManager {
    public static let shared = NetworkManager()
    
    public var networkState: ((NetworkStates) -> Void)?
    
    private init() {
    }
    
    open func fetchData<T: Decodable>(from response: Response, completionHandler: @escaping (Result<T, NetworkErrors>) -> Void) {
        networkState?(.processing)
        
        // MARK: URL
        guard let urlString = response.urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completionHandler(.failure(.clientError))
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        var urlRequest = URLRequest(url: url)
        
        // MARK: HTTP Method
        urlRequest.httpMethod = response.httpMethod.rawValue
        
        if let headers = response.headers {
            for element in headers {
                urlRequest.setValue(element.value, forHTTPHeaderField: element.key)
            }
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: { [weak self] data, response, error in

            if let statusCode = (response as? HTTPURLResponse)?.statusCode , !(200..<300 ~= statusCode) {
                let error = NetworkErrors(statusCode: statusCode)
                completionHandler(.failure(error))
                return
            }
            guard let data = data, error == nil else {
                self?.networkState?(.done)
                completionHandler(.failure(.unknown))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                self?.networkState?(.done)
                completionHandler(.success(decodedData))
            }
            catch {
                self?.networkState?(.clientError)
                completionHandler(.failure(.decodeError))
            }
        })
        task.resume()
    }
}
