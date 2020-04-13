//
//  URLSessionHTTPClientTests.swift
//  MenuAppTDDTests
//
//  Created by Vinicius Moreira Leal on 23/03/2020.
//  Copyright © 2020 Vinicius Leal and Gabriel Meira. All rights reserved.
//

import XCTest
import MenuAppTDD
import Combine

class URLSessionHTTPClientTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        URLProtocolStub.startInterceptingRequests()
    }
    
    override func tearDown() {
        super.tearDown()
        
        URLProtocolStub.stopInterceptingRequests()
    }
    
    func test_getFromURL_performsGETRequestWithURL() {
        let request = anyURLRequest()
        let exp = expectation(description: "Wait for request")

        var sub: Cancellable?
        let publisher = makeSUT().createPublisher(from: request)
        sub = publisher
            .sink(receiveCompletion: { _ in }, receiveValue: { _, _ in })
        
        URLProtocolStub.observeRequests { request in
            XCTAssertEqual(request.url, request.url)
            XCTAssertEqual(request.httpMethod, "GET")
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
        assertNotNil(sub)
    }
    
    func test_getFromURL_failsOnRequestError() {
        let requestError = anyNSError()
        let receivedError = publishErrorFor(data: nil, response: nil, error: requestError)
        XCTAssertEqual(receivedError as NSError?, requestError)
    }

    func test_getFromURL_failsOnAllInvalidRepresentationCases() {
        XCTAssertNotNil(publishErrorFor(data: nil, response: nil, error: nil))
        XCTAssertNotNil(publishErrorFor(data: anyData(), response: nil, error: nil))
        XCTAssertNotNil(publishErrorFor(data: anyData(), response: nil, error: anyNSError()))
        XCTAssertNotNil(publishErrorFor(data: nil, response: nonHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(publishErrorFor(data: nil, response: anyHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(publishErrorFor(data: anyData(), response: nonHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(publishErrorFor(data: anyData(), response: anyHTTPURLResponse(), error: anyNSError()))
    }

    func test_getFromURL_succeedsOnHTTPURLResponseWithData() {
        let data = anyData()
        let response = anyHTTPURLResponse()

        let receivedValues = publishValuesFor(data: data, response: response, error: nil)
        guard let httpURLResponse = receivedValues?.response as? HTTPURLResponse else {
            XCTFail("Unable to parse response HTTPURLResponse")
            return }

        XCTAssertEqual(receivedValues?.data, data)
        XCTAssertEqual(httpURLResponse.url, response.url)
        XCTAssertEqual(httpURLResponse.statusCode, response.statusCode)
    }
    
    func test_getFromURL_succeedsOnNonHTTPURLResponseWithData() {
        let data = anyData()
        let response = nonHTTPURLResponse()

        let receivedValues = publishValuesFor(data: data, response: response, error: nil)

        XCTAssertEqual(receivedValues?.data, data)
        XCTAssertEqual(receivedValues?.response.url, response.url)
    }

    func test_getFromURL_succeedsWithEmptyDataOnHTTPURLResponseWithNilData() {
        let response = anyHTTPURLResponse()

        let receivedValues = publishValuesFor(data: nil, response: response, error: nil)
        
        guard let httpURLResponse = receivedValues?.response as? HTTPURLResponse else {
        XCTFail("Unable to parse response HTTPURLResponse")
        return }

        let emptyData = Data()
        XCTAssertEqual(receivedValues?.data, emptyData)
        XCTAssertEqual(httpURLResponse.url, response.url)
        XCTAssertEqual(httpURLResponse.statusCode, response.statusCode)
    }
    
    func test_getFromURL_succeedsWithEmptyDataOnNonHTTPURLResponseWithNilData() {
        let response = nonHTTPURLResponse()

        let receivedValues = publishValuesFor(data: nil, response: response, error: nil)

        let emptyData = Data()
        XCTAssertEqual(receivedValues?.data, emptyData)
        XCTAssertEqual(receivedValues?.response.url, response.url)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> DataTaskPublisher {
        let sut = URLSessionHTTPClient()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func publishErrorFor(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #file, line: UInt = #line) -> Error? {
        let publisher = publisherFor(data: data, response: response, error: error, file: file, line: line)
        
        var sub: Cancellable? = nil
        let exp = XCTestExpectation(description: "wait for completion")
        var receivedError: URLError?
        
        sub = publisher
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTFail("Expected error, received \(completion), instead", file: file, line: line)
                case let .failure(error):
                    receivedError = error
                }
                exp.fulfill()
            }, receiveValue: { response in
                    XCTFail("Expected error, received \(response) instead", file: file, line: line)
            })
        
        wait(for: [exp], timeout: 1.0)
        assertNotNil(sub, file: file, line: line)
        return receivedError
    }
    
    private func publishValuesFor(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #file, line: UInt = #line) -> (data: Data, response: URLResponse)? {
        let publisher = publisherFor(data: data, response: response, error: error, file: file, line: line)
        
        var sub: Cancellable? = nil
        let exp = XCTestExpectation(description: "wait for completion")
        var receivedValue: (data: Data, response: URLResponse)?
        
        sub = publisher
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    exp.fulfill()
                case let .failure(error):
                    XCTFail("Expected a value, received \(error), instead", file: file, line: line)
                }
            }, receiveValue: { (data, response) in
                receivedValue = (data: data, response: response)
            })
        
        wait(for: [exp], timeout: 1.0)
        assertNotNil(sub, file: file, line: line)
        return receivedValue
    }
    
    private func publisherFor(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #file, line: UInt = #line) -> URLRequestPublisher {
        URLProtocolStub.stub(data: data, response: response, error: error)
        let sut = makeSUT(file: file, line: line)
        
        return sut.createPublisher(from: anyURLRequest())
    }
    
    private func assertNotNil(_ sub: Cancellable?, file: StaticString = #file, line: UInt = #line) {
        XCTAssertNotNil(sub, file: file, line: line)
    }
    
    func anyNSError() -> NSError {
        NSError(domain: "NSURLErrorDomain", code: -1, userInfo: nil)
    }
    
    private func anyHTTPURLResponse() -> HTTPURLResponse {
        HTTPURLResponse(url: anyURLRequest().url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    }
    
    // This class will allow us to pass Data, URLResponse, and Error, to simulate the behaviour of a network request.
    private class URLProtocolStub: URLProtocol {
        private static var stub: Stub?
        private static var requestObserver: ((URLRequest) -> Void)?
        
        private struct Stub {
            let data: Data?
            let response: URLResponse?
            let error: Error?
        }
        
        enum TestFailureCondition: Error {
            case invalidServerResponse
        }
        
        static func stub(data: Data?, response: URLResponse?, error: Error?) {
            stub = Stub(data: data, response: response, error: error)
        }
        
        static func observeRequests(observer: @escaping (URLRequest) -> Void) {
            requestObserver = observer
        }
        
        static func startInterceptingRequests() {
            URLProtocol.registerClass(URLProtocolStub.self)
        }
        
        static func stopInterceptingRequests() {
            URLProtocol.unregisterClass(URLProtocolStub.self)
            stub = nil
            requestObserver = nil
        }

        override class func canInit(with request: URLRequest) -> Bool { true }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }
        
        override func startLoading() {
            if let requestObserver = URLProtocolStub.requestObserver {
                client?.urlProtocolDidFinishLoading(self)
                return requestObserver(request)
            }

            if let data = URLProtocolStub.stub?.data {
                client?.urlProtocol(self, didLoad: data)
            }
            
            if let response = URLProtocolStub.stub?.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            if let error = URLProtocolStub.stub?.error {
                client?.urlProtocol(self, didFailWithError: error)
            }
            
            client?.urlProtocolDidFinishLoading(self)
        }
        
        override func stopLoading() {}
    }
}
