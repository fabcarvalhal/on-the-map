//
//  UdacityApiClient.swift
//  OnTheMap
//
//  Created by Fabrício Silva Carvalhal on 12/06/21.
//

import Foundation

protocol UdacityApiClientProtocol {
    
    func createSession(email: String,
                       password: String,
                       completion: @escaping (Result<UdacitySessionResponse>) -> Void)
}

final class UdacityApiClient: BaseApiClient, UdacityApiClientProtocol {

    init() {
        super.init()
    }
    
    func createSession(email: String,
                       password: String,
                       completion: @escaping (Result<UdacitySessionResponse>) -> Void) {
        
        let endpoint = UdacityEndpoint.createSession
        let loginInfo = UdacityLoginInfo(username: email, password: password)
        let requestBody = UdacitySessionRequestBody(udacity: loginInfo)
        
        
        do {
            let encoder = SimpleJSONHandler<UdacitySessionRequestBody>()
            let data = try encoder.encode(requestBody)
            let udacityRequest = try URLRequestBuilder(with: endpoint.baseUrl)
                .set(method: endpoint.method)
                .set(path: endpoint.path)
                .set(params: .body(data))
                .set(headers: endpoint.headers)
                .build()
            print(udacityRequest)
            makeRequest(with: udacityRequest,
                        jsonHandler: SimpleJSONHandler<UdacitySessionResponse>(decodeDataAfter: 5),
                        completion: completion)
        } catch let error {
            completion(.failure(error))
        }
    }
    
    
}
