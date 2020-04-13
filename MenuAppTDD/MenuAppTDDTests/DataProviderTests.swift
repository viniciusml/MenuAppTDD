//
//  DataProviderTests.swift
//  MenuAppTDDTests
//
//  Created by Vinicius Moreira Leal on 12/04/2020.
//  Copyright © 2020 Vinicius Leal and Gabriel Meira. All rights reserved.
//

import XCTest
import MenuAppTDD
import Combine

class DataProviderTests: XCTestCase {
    
    private typealias DataProviderResult = Result<Response, Error>
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.urls.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "http://any-url.com")!
        let (sut, client) = makeSUT(url: anyURL())

        _ = sut.load()

        XCTAssertEqual(client.urls, [url])
    }

    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "http://any-url.com")!
        let (sut, client) = makeSUT(url: anyURL())

        _ = sut.load()
        _ = sut.load()

        XCTAssertEqual(client.urls, [url, url])
    }

    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: failure(.invalidData), when: {
            let clientError = anyURLError()
            client.complete(with: clientError)
        })
    }

    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()

        let samples = [199, 180, 300, 400, 500]

        samples.forEach { code in
            expect(sut, toCompleteWith: failure(.invalidHTTPStatusCode), when: {
                let json = makeItemsJSON([])
                client.complete(withStatusCode: code, data: json)
            })
        }
    }
    
    func test_load_deliversErrorOnNonHTTPResponse() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: failure(.connectivity), when: {
            let json = makeItemsJSON([])
            client.complete(with: json, response: nonHTTPURLResponse())
        })
    }

    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: failure(.invalidData), when: {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }

    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()
        let emptyResponse = Response(categories: [])
        
        expect(sut, toCompleteWith: .success(emptyResponse), when: {
            let emptyResponseJSON = makeItemsJSON([])
            client.complete(withStatusCode: 200, data: emptyResponseJSON)
        })
    }

    func test_load_deliversItemsOn200HTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()
        let response = makeResponse()

        expect(sut, toCompleteWith: .success(response.model), when: {
            let json = try! JSONSerialization.data(withJSONObject: response.json)
            client.complete(withStatusCode: 200, data: json)
        })
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!, file: StaticString = #file, line: UInt = #line) -> (sut: DataProvider, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = DataProvider(request: URLRequest(url: url), client: client)
        trackForMemoryLeaks(client, file: file, line: line)
        return (sut, client)
    }
    
    private func expect(_ sut: DataProvider, toCompleteWith expectedResult: DataProviderResult, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "wait for load completion")
        
        var sub: Cancellable? = nil
        let publisher = sut.load()
        
        sub = publisher
            .mapError { $0 as NSError }
            .sink(receiveCompletion: { completion in
                
                switch (completion, expectedResult) {
                case (.finished, _): exp.fulfill()
                case let (.failure(receivedError), .failure(expectedError)):
                    XCTAssertEqual(receivedError, expectedError as NSError, file: file, line: line)
                default:
                    XCTFail("Expected completion \(expectedResult) but got \(completion) instead", file: file, line: line)
                }
                exp.fulfill()
                
            }, receiveValue: { value in
                
                switch (value, expectedResult) {
                case let (value, .success(expectedValue)):
                    XCTAssertEqual(value, expectedValue)
                default:
                    XCTFail("Expected value \(expectedResult), received \(value) instead", file: file, line: line)
                }
                exp.fulfill()
            })
        
        action()
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertNotNil(sub)
    }
    
    private func failure(_ error: DataProvider.NetworkError) -> DataProviderResult {
        return .failure(error)
    }

    private func makeResponse() -> (model: Response, json: [String: Any]) {
        let item = Response(categories: [Category(categories: Categories(id: 1, name: "Delivery")),
                                         Category(categories: Categories(id: 2, name: "Dine-out"))])
        
        let json: [String: Any] = [
            "categories": [
                [ "categories": [
                    "id": 1,
                    "name": "Delivery"
                    ]],
                [ "categories": [
                    "id": 2,
                    "name": "Dine-out"
                    ]]]]
        
        return (item, json)
    }
    
    private func makeItemsJSON(_ items: [[String: Any]]) -> Data {
        let json = ["categories": items]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    private func anyURLError() -> URLError {
        return URLError(.unknown)
    }
    
    private class HTTPClientSpy: DataTaskPublisher {
        
        private var requests = [URLRequest]()
        
        var urls: [URL?] {
            requests.map { $0.url }
        }
        
        let simplePublisher = PassthroughSubject<(data: Data, response: URLResponse), URLError>()
        
        func createPublisher(from request: URLRequest) -> URLRequestPublisher {
            requests.append(request)
            return simplePublisher.eraseToAnyPublisher()
        }
        
        func complete(with error: URLError) {
            simplePublisher.send(completion: .failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data) {
            let response = HTTPURLResponse(
                url: urls[0]!,
                statusCode: code,
                httpVersion: nil,
                headerFields: nil
                )!
            simplePublisher.send((data: data, response: response))
        }
        
        func complete(with data: Data, response: URLResponse) {
            simplePublisher.send((data: data, response: response))
        }
    }
}
