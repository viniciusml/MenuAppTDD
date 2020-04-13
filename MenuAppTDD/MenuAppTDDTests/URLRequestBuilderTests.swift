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
    
    func test_init_doesNotBuildRequest() {
        let sut = URLRequestBuilderStub()
        XCTAssertTrue(sut.endpoints.isEmpty)
    }
    
    func test_buildRequest_usesCorrectEndpoint() {
        let endpoint: Endpoint = "/exampleEndpoint"
        let sut = URLRequestBuilderStub()
        
        _ = sut.buildRequest(for: endpoint)
        XCTAssertEqual(sut.endpoints, [endpoint])
    }
    
    func test_buildRequest_appendsEndpointToBaseURL() {
        let baseURL = "https://base-url.com"
        let endpoint: Endpoint = "/exampleEndpoint"
        let sut = URLRequestBuilderStub()
        
        let request = sut.buildRequest(for: endpoint)
        XCTAssertEqual(request.url?.absoluteString, baseURL + endpoint)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> RequestBuilder {
        return URLRequestBuilderStub()
    }
    
    private class URLRequestBuilderStub: RequestBuilder {
        
        var endpoints = [Endpoint]()
        
        private let baseURL = "https://base-url.com"
        
        func buildRequest(for endpoint: Endpoint) -> URLRequest {
            endpoints.append(endpoint)
            let url = URL(string: baseURL + endpoint)!
            let request = URLRequest(url: url)
            return request
        }
    }
}
