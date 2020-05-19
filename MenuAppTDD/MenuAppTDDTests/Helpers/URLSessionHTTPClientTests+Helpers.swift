//
//  URLSessionHTTPClientTests+Helpers.swift
//  MenuAppTDDTests
//
//  Created by Vinicius Moreira Leal on 19/05/2020.
//  Copyright © 2020 Vinicius Leal and Gabriel Meira. All rights reserved.
//

import Combine
import XCTest
import MenuAppTDD

extension URLSessionHTTPClientTests {

    func makeSUT(file: StaticString = #file, line: UInt = #line) -> DataTaskPublisher {
        let sut = URLSessionHTTPClient()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

    func publishErrorFor(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #file, line: UInt = #line) -> Error? {
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

    func publishValuesFor(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #file, line: UInt = #line) -> (data: Data, response: URLResponse)? {
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

    func publisherFor(data: Data?, response: URLResponse?, error: Error?, file: StaticString = #file, line: UInt = #line) -> URLRequestPublisher {
        URLProtocolStub.stub(data: data, response: response, error: error)
        let sut = makeSUT(file: file, line: line)

        return sut.createPublisher(from: anyURLRequest())
    }

    func assertNotNil(_ sub: Cancellable?, file: StaticString = #file, line: UInt = #line) {
        XCTAssertNotNil(sub, file: file, line: line)
    }

    func anyNSError() -> NSError {
        NSError(domain: "NSURLErrorDomain", code: -1, userInfo: nil)
    }

    func anyHTTPURLResponse() -> HTTPURLResponse {
        HTTPURLResponse(url: anyURLRequest().url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    }
}
