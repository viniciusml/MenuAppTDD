//
//  URLRequestBuilderTests.swift
//  MenuAppTDDTests
//
//  Created by Vinicius Moreira Leal on 13/04/2020.
//  Copyright © 2020 Vinicius Leal and Gabriel Meira. All rights reserved.
//

import XCTest
import MenuAppTDD

class URLRequestBuilderTests: XCTestCase {
    
    func test_buildRequest_usesCorrectEndpoint() {
        let endpoint = exampleEndpoint()
        let sut = makeSUT(urlStr: baseURL())
        
        let request = sut.buildRequest(for: endpoint)
        
        XCTAssertEqual(request.url?.path, endpoint)
    }
    
    func test_buildRequest_appendsEndpointToBaseURL() {
        let url = baseURL()
        let endpoint = exampleEndpoint()
        let sut = makeSUT(urlStr: url)
        
        let request = sut.buildRequest(for: endpoint)
        
        XCTAssertEqual(request.url?.absoluteString, url + endpoint)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(urlStr: String, headers: [String: String] = [:]) -> RequestBuilder {
        return URLRequestBuilder(urlString: urlStr, headers: headers)
    }
    
    private func baseURL() -> String {
        return "https://base-url.com"
    }
    
    private func exampleEndpoint() -> Endpoint {
        return "/exampleEndpoint"
    }
}
