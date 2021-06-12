//
//  UdacityApiClient.swift
//  OnTheMap
//
//  Created by Fabrício Silva Carvalhal on 12/06/21.
//

import Foundation

/// Conform a struct
protocol DictionaryConvertible {
    
    func toDictionary() -> [String: Any]
}

extension DictionaryConvertible {
    
    func toDictionary() -> [String: Any] {
        let mirror = Mirror(reflecting: self)
        let keyValuePairs = mirror
            .children
            .lazy
            .map({ (label: String?, value: Any) -> (String, Any)? in
                guard let label = label else { return nil }
            return (label, value)
            }).compactMap { $0 }
        return Dictionary<String, Any>(uniqueKeysWithValues: keyValuePairs)
    }
}

struct StudentLocationRequest: DictionaryConvertible {
    
    let limit: Int
    let skip: Int
    let order: String
}

struct StudentLocationResponse: Codable {
    
    let results: [StudentLocationResponseItem]
}

struct StudentLocationResponseItem: Codable {
    
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: String
    let updatedAt: String
}

protocol UdacityApiClientProtocol {
    
    func createSession(requestBody: UdacitySessionRequestBody,
                       completion: @escaping (Result<UdacitySessionResponse>) -> Void)
    
    func getStudentLocations(studentLocationRequest: StudentLocationRequest,
                             completion: @escaping (Result<StudentLocationResponse>) -> Void)
}

final class UdacityApiClient: BaseApiClient, UdacityApiClientProtocol {

    init() {
        super.init()
    }
    
    func getStudentLocations(studentLocationRequest: StudentLocationRequest,
                             completion: @escaping (Result<StudentLocationResponse>) -> Void) {
        let endpoint = LocationEndpoint.list
        
        do {
            let udacityRequest = try URLRequestBuilder(with: endpoint.baseUrl)
                .set(method: endpoint.method)
                .set(path: endpoint.path)
                .set(params: .query(studentLocationRequest.toDictionary()))
                .set(headers: endpoint.headers)
                .build()
            makeRequest(with: udacityRequest,
                        completion: completion)
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func createSession(requestBody: UdacitySessionRequestBody,
                       completion: @escaping (Result<UdacitySessionResponse>) -> Void) {
        
        let endpoint = UdacitySessionEndpoint.create
        
        do {
            let encoder = SimpleJSONHandler<UdacitySessionRequestBody>()
            let data = try encoder.encode(requestBody)
            let udacityRequest = try URLRequestBuilder(with: endpoint.baseUrl)
                .set(method: endpoint.method)
                .set(path: endpoint.path)
                .set(params: .body(data))
                .set(headers: endpoint.headers)
                .build()
            makeRequest(with: udacityRequest,
                        jsonHandler: SimpleJSONHandler<UdacitySessionResponse>(decodeDataAfter: 5),
                        completion: completion)
        } catch let error {
            completion(.failure(error))
        }
    }
}
