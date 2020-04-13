//
//  DataProvider.swift
//  MenuAppTDD
//
//  Created by Vinicius Moreira Leal on 30/01/2020.
//  Copyright © 2020 Vinicius Leal and Gabriel Meira. All rights reserved.
//

import Foundation
import Combine

/*
    Key Concepts
 - A publisher is a provider of data, when it is available and requested.
 - A subscriber is resposible for requesting data, accepting data and control the ammount of data reveived.
 - A Operator is an object that acts both as publisher and subscriber.
 - A subject is a publisher that you can use to inject values into stream, by calling its send method.
 
    Lifecycle
 1 - When the subscriber is attached to a publisher, it stars with a call to subscriber.
 2 - The publisher in turn acknowledges the subscriber, calling receive(subscription).
 3 - After the subscription has been aknowledged, the subscriber requests N values with request(_: Demand).
 4 - The publisher may then send N values with receive(_: Input). A publisher should never send more than the demand requested.
 5 - Also after the subscription has been aknowledged, the subscriber can send a cancellation with cancel().
 6 - A publisher may optionally send completion with receive(completion). A completion can either be a normal termination, or may be a .failure completion, optionally propagating an error type.
 */

public struct DataProvider {
    
    public let request: URLRequest
    public let client: DataTaskPublisher
    
    public enum NetworkError: Error {
        case connectivity
        case invalidHTTPStatusCode
        case invalidData
    }
    
    public init(request: URLRequest, client: DataTaskPublisher) {
        self.request = request
        self.client = client
    }
    
    public func load() -> AnyPublisher<Response, Error> {
        return client.createPublisher(from: request)
            .tryMap { try DataProvider.validate($0.data, $0.response) }
            .decode(type: Response.self, decoder: JSONDecoder())
            .mapError { ($0 as? NetworkError ?? NetworkError.invalidData) }
            .eraseToAnyPublisher()
    }
    
    private static func validate(_ data: Data, _ response: URLResponse) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.connectivity
        }
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidHTTPStatusCode
        }
        return data
    }
}
