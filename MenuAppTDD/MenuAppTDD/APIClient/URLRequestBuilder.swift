//
//  RequestBuilder.swift
//  MenuAppTDD
//
//  Created by Vinicius Moreira Leal on 13/04/2020.
//  Copyright © 2020 Vinicius Leal and Gabriel Meira. All rights reserved.
//

import Foundation

public typealias Endpoint = String

public protocol RequestBuilder {
    func buildRequest(for endpoint: Endpoint) -> URLRequest
}

public struct URLRequestBuilder: RequestBuilder {
    
    private let baseURL = "https://developers.zomato.com/api/v2.1"
    
    private let defaultHeaders: [String: String] = [
        "Content-Type": "application/json",
        "user-key": "d25a516a7a59fb465b3b1440a2c92621"
    ]
    
    public init() {}
        
    public func buildRequest(for endpoint: Endpoint = "/categories") -> URLRequest {
        guard let url = URL(string: baseURL + endpoint ) else {
            fatalError("Invalid URL")
        }

        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = defaultHeaders
        return request
    }
}
