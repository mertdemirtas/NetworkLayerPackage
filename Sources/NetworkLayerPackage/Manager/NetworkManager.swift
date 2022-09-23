//
//  NetworkManager.swift
//  NetworkLayer
//
//  Created by Mert Demirtaş on 16.04.2022.
//

import Foundation
import Combine

@available(iOS 13.0, *)
public class NetworkManager {
    public static let shared = NetworkManager()
    
    let networkConnection = NetworkConnection()
    
    private init() {
    }
    
    public var networkState: ((NetworkStates) -> Void)?
    
    
    public func checkConnectionStatus(closure: (NetworkError?) -> Void) {
        switch(networkConnection.connectionStatus) {
        case true:
            closure(nil)
        case false:
            closure(NetworkError.init(error: .internetConnectionError))
        }
    }
    
    public func request<T: Codable>(endpoint: Endpoint, completionHandler: @escaping (Result<T, NetworkError>) -> Void) {
        // MARK: Connection Check
        checkConnectionStatus(closure: { [weak self] error in
            if let error = error {
                self?.networkState?(.error(error))
                completionHandler(.failure(error))
            }
        })
        
        networkState?(.processing)
        
        // MARK: URL
        guard let urlString = endpoint.urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completionHandler(.failure(.init(error: .httpError(.clientError(.badRequest)))))
            return
        }
        
        guard let url = URL(string: urlString) else {
            networkState?(.error(NetworkError(error: .httpError(.clientError(.badRequest)))))
            completionHandler(.failure(.init(error: .httpError(.clientError(.badRequest)))))
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
    
    private func taskHandler<T: Codable>(data: Data?, response: URLResponse?, error: Error?, completionHandler: @escaping (Result<T, NetworkError>) -> Void) {
        
        if let statusCode = (response as? HTTPURLResponse)?.statusCode , !(200..<300 ~= statusCode) {
            let error = NetworkErrorOrganaizer.organize(statusCode: statusCode)
            networkState?(.error(NetworkError.init(error: .httpError(error))))
            completionHandler(.failure(.init(error: NetworkErrorsType.httpError(error))))
            return
        }
        
        guard let data = data, error == nil else {
            self.networkState?(.done)
            completionHandler(.failure(.init(error: .unknown)))
            return
        }
        
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            self.networkState?(.done)
            completionHandler(.success(decodedData))
        }
        catch {
            self.networkState?(.error(NetworkError.init(error: .encodeError)))
            completionHandler(.failure(.init(error: .encodeError)))
        }
    }
}
