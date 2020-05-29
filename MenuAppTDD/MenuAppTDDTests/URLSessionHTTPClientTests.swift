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

    var cancellables = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        
        URLProtocolStub.startInterceptingRequests()
    }
    
    override func tearDown() {
        super.tearDown()
        
        URLProtocolStub.stopInterceptingRequests()
        cancellables = []
    }
    
    func test_getFromURL_performsGETRequestWithURL() {
        let request = anyURLRequest()
        let exp = expectation(description: "Wait for request")

        makeSUT().createPublisher(from: request)
            .sink(receiveCompletion: { _ in }, receiveValue: { _, _ in })
            .store(in: &cancellables)
        
        URLProtocolStub.observeRequests { request in
            XCTAssertEqual(request.url, request.url)
            XCTAssertEqual(request.httpMethod, "GET")
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
    }
    
    func test_getFromURL_failsOnRequestError() {
        let requestError = anyNSError()
        let receivedError = publishErrorFor(data: nil, response: nil, error: requestError)
        XCTAssertEqual(receivedError as NSError?, requestError)
    }

    func test_getFromURL_failsOnAllInvalidRepresentationCases() {
        XCTAssertNotNil(publishErrorFor(data: nil, response: nil, error: nil))
        XCTAssertNotNil(publishErrorFor(data: nil, response: nil, error: anyNSError()))
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
    
}
