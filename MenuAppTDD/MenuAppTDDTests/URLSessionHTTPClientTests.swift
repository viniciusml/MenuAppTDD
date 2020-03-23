//
//  URLSessionHTTPClientTests.swift
//  MenuAppTDDTests
//
//  Created by Vinicius Moreira Leal on 23/03/2020.
//  Copyright © 2020 Vinicius Leal and Gabriel Meira. All rights reserved.
//

import XCTest
import MenuAppTDD

class URLSessionHTTPClient {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func get(from url: URL) -> Result<[CategoryItem], Error> {
        session.dataTask(with: url) { _, _, _ in }.resume()
        return .failure(NSError(domain: "Test", code: 1))
    }
}

class URLSessionHTTPClientTests: XCTestCase {
    
    func test_getFromURL_failsOnRequestError() {
        URLProtocolStub.startInterceptingRequests()
        
        let url = URL(string: "http://any-url.com")!
        let error = NSError(domain: "Test", code: 1)
        URLProtocolStub.stub(url: url, error: error)
        
        let sut = URLSessionHTTPClient()
        
        let result = sut.get(from: url)
        switch result {
        case let .failure(receivedError as NSError):
            XCTAssertEqual(receivedError, error)
        default:
            XCTFail("Expected failure with \(error), got \(result) instead")
        }
        
        URLProtocolStub.stopInterceptingRequests()
    }
    
    // MARK: - Helpers
    
    private class URLProtocolStub: URLProtocol {
        
        private static var stubs = [URL: Stub]()
        
        private struct Stub {
            let error: Error?
        }
                
        static func stub(url: URL, error: Error? = nil) {
            stubs[url] = Stub(error: error)
        }
        
        static func startInterceptingRequests() {
            URLProtocol.registerClass(URLProtocolStub.self)
        }
        
        static func stopInterceptingRequests() {
            URLProtocol.unregisterClass(URLProtocolStub.self)
            stubs = [:]
        }
        
        override class func canInit(with request: URLRequest) -> Bool {
            guard let url = request.url else { return false }
            
            return URLProtocolStub.stubs[url] != nil
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }
        
        override func startLoading() {
            guard let url = request.url, let stub = URLProtocolStub.stubs[url] else { return }
            
            if let error = stub.error {
                client?.urlProtocol(self, didFailWithError: error)
            }
            
            client?.urlProtocolDidFinishLoading(self)
        }
        
        override func stopLoading() {}
    }
}
