//
//  RequestBuilder.swift
//  MenuAppTDD
//
//  Created by Vinicius Moreira Leal on 13/04/2020.
//  Copyright © 2020 Vinicius Leal and Gabriel Meira. All rights reserved.
//

import Foundation

struct RequestBuilder {
    
    private let baseURL = "https://developers.zomato.com/api/v2.1"
    
    private let defaultHeaders: [String: String] = [
        "Content-Type": "application/json",
        "user-key": "d25a516a7a59fb465b3b1440a2c92621"
    ]
    
    typealias Endpoint = String
    let endpoint: Endpoint
    
    init(endpoint: Endpoint) {
        self.endpoint = endpoint
    }
        
    func buildRequest(_ endpoint: Endpoint = "/categories") -> URLRequest {
        guard let url = URL(string: baseURL + endpoint ) else {
            fatalError("Invalid URL")
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = defaultHeaders
        return request
    }
}
