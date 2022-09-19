//
//  NetworkManager.swift
//  NetworkLayer
//
//  Created by Mert Demirtaş on 16.04.2022.
//

import Foundation

public class NetworkManager {
    public static let shared = NetworkManager()
    
    private init() {
    }
    
    public var networkState: ((NetworkStates) -> Void)?
    
    public func request<T: Codable>(from response: Response, completionHandler: @escaping (Result<T, NetworkErrors>) -> Void) {
        networkState?(.processing)
        
        // MARK: URL
        guard let urlString = response.urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completionHandler(.failure(.clientError))
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        var urlRequest = URLRequest(url: url)
        
        // MARK: HTTP Method
        urlRequest.httpMethod = response.httpMethod?.rawValue
        
        if let body = response.body {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
                return
            }
        }
        
        if let headers = response.headers {
            for element in headers {
                urlRequest.setValue(element.value, forHTTPHeaderField: element.key)
            }
        }
        
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { [weak self] data, response, error in
            self?.taskHandler(data: data, response: response, error: error, completionHandler: completionHandler)
        }).resume()
    }
    
    private func taskHandler<T: Codable>(data: Data?, response: URLResponse?, error: Error?, completionHandler: @escaping (Result<T, NetworkErrors>) -> Void) {
        
        if let statusCode = (response as? HTTPURLResponse)?.statusCode , !(200..<300 ~= statusCode) {
            let error = NetworkErrors(statusCode: statusCode)
            networkState?(.error(error))
            completionHandler(.failure(error))
            return
        }
        
        guard let data = data, error == nil else {
            self.networkState?(.done)
            completionHandler(.failure(.unknown))
            return
        }
        
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            self.networkState?(.done)
            completionHandler(.success(decodedData))
        }
        catch {
            self.networkState?(.error(.clientError))
            completionHandler(.failure(.decodeError))
        }
    }
}
