//
//  UdacityURLRequester.swift
//  OnTheMap
//
//  Created by Fabrício Silva Carvalhal on 05/06/21.
//

import Foundation

struct UdacityError: Codable {
    
    let status: Int
    let error: String
}

final class UdacityURLRequester: URLRequesterProtocol {
    
    func makeRequest<T: Codable>(with request: URLRequest, completion: ((Result<T>) -> Void)?) {
        URLSession.shared.dataTask(with: request) { (data, response, error) in
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
                    try self.handleResponseCode(urlResponse.statusCode)
                } catch {
                    completion?(.failure(error))
                    return
                }
            } else {
                completion?(.failure(URLRequesterError.emptyResponse))
                return
            }
            
            do {
                let range = 5..<data.count
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let response = try decoder.decode(T.self, from: data.subdata(in: range))
                completion?(.success(response))
            } catch {
                completion?(.failure(URLRequesterError.parseError))
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
