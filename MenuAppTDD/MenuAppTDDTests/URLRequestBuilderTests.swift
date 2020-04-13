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
        
        _ = sut.buildRequestFor(endpoint)
        XCTAssertEqual(sut.endpoints, [endpoint])
    }
    
    // MARK: - Helpers
    
    private class URLRequestBuilderStub: RequestBuilder {
        
        var endpoints = [Endpoint]()
        
        func buildRequestFor(_ endpoint: Endpoint) -> URLRequest {
            endpoints.append(endpoint)
            return URLRequest(url: URL(string: "http://any-url.com")!)
        }
    }
}
