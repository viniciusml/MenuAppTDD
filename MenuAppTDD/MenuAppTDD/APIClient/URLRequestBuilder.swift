//
//  RequestBuilder.swift
//  MenuAppTDD
//
//  Created by Vinicius Moreira Leal on 13/04/2020.
//  Copyright © 2020 Vinicius Leal and Gabriel Meira. All rights reserved.
//

import Foundation

public typealias Endpoint = String
public typealias HTTPMethod = String

public struct URLRequestBuilder {
    
    private let urlString: String
    private let headers: [String: String]
    
    public init(urlString: String, headers: [String: String]) {
        self.urlString = urlString
        self.headers = headers
    }
        
    public func buildRequest(for endpoint: Endpoint, method: HTTPMethod = "GET") -> URLRequest {
        guard let url = URL(string: urlString + endpoint ) else {
            fatalError("Invalid URL")
        }

        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = method
        return request
    }
}
