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
    
    typealias DataProviderResult = Result<Response, Error>

    var cancellables = Set<AnyCancellable>()
    
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
}
