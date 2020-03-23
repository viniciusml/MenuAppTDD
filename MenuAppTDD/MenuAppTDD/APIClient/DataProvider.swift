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


enum APIFailureCondition: Error {
    case invalidServerResponse
}

protocol APIDataTaskPublisher {
    func dataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher
}

class APISessionDataPublisher: APIDataTaskPublisher {
    
    func dataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher {
        return session.dataTaskPublisher(for: request)
    }
    
    var session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
}

class Example {
    func EXAMPLEgetData(_ url: URL) -> Future<Any, APIFailureCondition> {
        let session = URLSession.shared
        return Future { promise in
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    promise(.failure(.invalidServerResponse))
                } else {
                    if let data = data {
                        promise(.success(data))
                    }  else {
                        let unknownError = APIFailureCondition.invalidServerResponse
                        promise(.failure(unknownError))
                    }
                }
            }
            task.resume()
        }
    }
    
    static let baseURL = "http://localhost:8080"
    
    static let defaultHeaders = [
        "Content-Type": "application/json",
        "cache-control": "no-cache",
    ]
    
    static var publisher: APIDataTaskPublisher = APISessionDataPublisher()
    
    private static func buildGetTodoRequest(authToken: String) -> URLRequest {
        
        let headers = buildHeaders(key: "Authorization", value: "Bearer \(authToken)")
        guard let url = URL(string: baseURL + "/todos" ) else {
            fatalError("APIError.invalidEndpoint")
        }
        var request = URLRequest(url: url, timeoutInterval: timeoutInterval)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        return request
    }

    internal static func getTodoDTP(authToken: String) -> URLSession.DataTaskPublisher {
        let request = buildGetTodoRequest(authToken: authToken)
        return publisher.dataTaskPublisher(for: request)
    }
    
    internal static func buildHeaders(key: String, value: String) -> [String: String] {
        var headers = defaultHeaders
        headers[key] = value
        return headers
    }
    
    static var timeoutInterval: TimeInterval = 10.0
    
    static func AMAZINGEXAMPLEgetData(_ url: URL) -> AnyPublisher<[CategoryItem], Never> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { try validate($0.data, $0.response) }
            .decode(type: [CategoryItem].self, decoder: JSONDecoder())
            .replaceError(with: [CategoryItem(categoryID: "0", categoryName: "Error Category")])
            .eraseToAnyPublisher()
    }
    
    internal static func validate(_ data: Data, _ response: URLResponse) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIFailureCondition.invalidServerResponse
        }
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw APIFailureCondition.invalidServerResponse
        }
        return data
    }
}

class DataProvider {
    
    
}
