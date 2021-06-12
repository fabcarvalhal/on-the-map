//
//  APIClient.swift
//  OnTheMap
//
//  Created by Fabrício Silva Carvalhal on 05/06/21.
//

import Foundation

protocol URLRequesterProtocol {
    
    func makeRequest(with request: URLRequest, completion: ((Result<Data>) -> Void)?)
}

enum URLRequesterError: Error {
    
    case emptyResponse
    case emptyData
    case unauthorized
    case serverError
    case urlSessionError(Error)
}

final class URLRequester: URLRequesterProtocol {
    
    func makeRequest(with request: URLRequest, completion: ((Result<Data>) -> Void)?) {
        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            if let error = error {
                completion?(.failure(URLRequesterError.urlSessionError(error)))
                return
            }
            guard let data = data else {
                completion?(.failure(URLRequesterError.emptyData))
                return
            }
            
            if let urlResponse = response as? HTTPURLResponse {
                do {
                    try self?.handleResponseCode(urlResponse.statusCode)
                    completion?(.success(data))
                } catch let error {
                    completion?(.failure(error))
                }
            } else {
                completion?(.failure(URLRequesterError.emptyResponse))
            }
        }.resume()
    }
    
    func handleResponseCode(_ statusCode: Int) throws {
        switch statusCode {
        case 200..<300:
            return
        case 400..<500:
            throw URLRequesterError.unauthorized
        case 500..<600:
            throw URLRequesterError.serverError
        default:
            throw URLRequesterError.serverError
        }
    }
}
