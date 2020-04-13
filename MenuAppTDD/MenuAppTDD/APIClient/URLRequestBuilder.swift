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

struct URLRequestComponent {
    static let baseURL = "https://developers.zomato.com/api/v2.1"
    
    static let defaultHeaders: [String: String] = [
        "Content-Type": "application/json",
        "user-key": "d25a516a7a59fb465b3b1440a2c92621"
    ]
    
    static let categoriesEndpoint: Endpoint = "/categories"
}

public struct URLRequestBuilder: RequestBuilder {
    
    private let urlString: String
    private let headers: [String: String]
    
    public init(urlString: String, headers: [String: String]) {
        self.urlString = urlString
        self.headers = headers
    }
        
    public func buildRequest(for endpoint: Endpoint) -> URLRequest {
        guard let url = URL(string: urlString + endpoint ) else {
            fatalError("Invalid URL")
        }

        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        return request
    }
}
