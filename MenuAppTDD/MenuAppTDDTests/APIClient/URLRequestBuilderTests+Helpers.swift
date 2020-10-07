//
//  URLRequestBuilderTests+Helpers.swift
//  MenuAppTDDTests
//
//  Created by Vinicius Moreira Leal on 19/05/2020.
//  Copyright © 2020 Vinicius Leal and Gabriel Meira. All rights reserved.
//

import Foundation
import MenuAppTDD

extension URLRequestBuilderTests {

    func makeSUT(urlStr: String, headers: [String: String] = [:]) -> URLRequestBuilder {
        URLRequestBuilder(urlString: urlStr, headers: headers)
    }

    func baseURL() -> String {
        "https://base-url.com"
    }

    func exampleEndpoint() -> Endpoint {
        "/exampleEndpoint"
    }

    func defaultHeaders() -> [String: String] {
        ["Test": "Header"]
    }
}
