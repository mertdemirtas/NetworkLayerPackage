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
    
    public func request<T: Codable>(endpoint: Endpoint, completionHandler: @escaping (GenericResponse<T>) -> Void) {
        networkState?(.processing)
        // MARK: URL
        
        guard let urlString = endpoint.urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completionHandler(.init(response: nil, networkError: .httpError(.clientError(.badRequest))))
            return
        }
        
        guard let url = URL(string: urlString) else {
            networkState?(.error(.httpError(.clientError(.badRequest))))
            completionHandler(.init(response: nil, networkError: .httpError(.clientError(.badRequest))))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        
        // MARK: HTTP Method
        urlRequest.httpMethod = endpoint.httpMethod.rawValue
        
        if let body = endpoint.body {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
                return
            }
        }
        
        if let headers = endpoint.headers {
            for element in headers {
                urlRequest.setValue(element.value, forHTTPHeaderField: element.key)
            }
        }
        
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { [weak self] data, response, error in
            self?.taskHandler(data: data, response: response, error: error, completionHandler: completionHandler)
        }).resume()
    }
    
    private func taskHandler<T: Codable>(data: Data?, response: URLResponse?, error: Error?, completionHandler: @escaping (GenericResponse<T>) -> Void) {
        
        if let statusCode = (response as? HTTPURLResponse)?.statusCode , !(200..<300 ~= statusCode) {
            let error = NetworkErrorOrganaizer.organize(statusCode: statusCode)
            networkState?(.error(.httpError(error)))
            completionHandler(.init(response: nil, networkError: .httpError(error)))
            return
        }
        
        guard let data = data, error == nil else {
            self.networkState?(.done)
            completionHandler(.init(response: nil, networkError: .unknown))
            return
        }
        
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            self.networkState?(.done)
            completionHandler(.init(response: decodedData, networkError: nil))
        }
        catch {
            self.networkState?(.error(.encodeError))
            completionHandler(.init(response: nil, networkError: .encodeError))
        }
    }
}
