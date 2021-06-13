//
//  UdacityApiClient.swift
//  OnTheMap
//
//  Created by Fabrício Silva Carvalhal on 12/06/21.
//

import Foundation

protocol UdacityApiClientProtocol {
    
    func createSession(requestBody: UdacitySessionRequestBody,
                       completion: @escaping (Result<UdacitySessionResponse>) -> Void)
    
    func getStudentLocations(studentLocationRequest: StudentLocationRequest,
                             completion: @escaping (Result<StudentLocationResponse>) -> Void)
    
    func addStudentLocation(studentLocationRequest: AddStudentLocationRequestBody,
                            completion: @escaping (Result<AddStudentLocationResponse>) -> Void)
    
    func getStudentUserData(studentId: String,
                            completion: @escaping (Result<GetUserDataResponse>) -> Void)
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
    
    func addStudentLocation(studentLocationRequest: AddStudentLocationRequestBody,
                            completion: @escaping (Result<AddStudentLocationResponse>) -> Void) {
        let endpoint = LocationEndpoint.add
        
        do {
            let encoder = SimpleJSONHandler<AddStudentLocationRequestBody>()
            let data = try encoder.encode(studentLocationRequest)
            let udacityRequest = try URLRequestBuilder(with: endpoint.baseUrl)
                .set(method: endpoint.method)
                .set(path: endpoint.path)
                .set(params: .body(data))
                .set(headers: endpoint.headers)
                .build()
            makeRequest(with: udacityRequest,
                        completion: completion)
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func getStudentUserData(studentId: String,
                            completion: @escaping (Result<GetUserDataResponse>) -> Void) {
        let endpoint = UdacitySessionEndpoint.getUserData(userId: studentId)
        
        do {
            let udacityRequest = try URLRequestBuilder(with: endpoint.baseUrl)
                .set(method: endpoint.method)
                .set(path: endpoint.path)
                .set(headers: endpoint.headers)
                .build()
            makeRequest(with: udacityRequest,
                        jsonHandler: SimpleJSONHandler<GetUserDataResponse>(decodeDataAfter: 5),
                        completion: completion)
        } catch let error {
            completion(.failure(error))
        }
    }
}
