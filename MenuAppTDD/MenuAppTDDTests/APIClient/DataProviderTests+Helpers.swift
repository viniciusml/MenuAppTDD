//
//  DataProviderTests+Helpers.swift
//  MenuAppTDDTests
//
//  Created by Vinicius Moreira Leal on 19/05/2020.
//  Copyright © 2020 Vinicius Leal and Gabriel Meira. All rights reserved.
//

import Combine
import MenuAppTDD
import XCTest

extension DataProviderTests {

    func makeSUT(url: URL = URL(string: "https://a-url.com")!, file: StaticString = #file, line: UInt = #line) -> (sut: DataProvider, client: HTTPClientStub) {
        let client = HTTPClientStub()
        let sut = DataProvider(request: URLRequest(url: url), client: client)
        trackForMemoryLeaks(client, file: file, line: line)
        return (sut, client)
    }

    func expect(_ sut: DataProvider, toCompleteWith expectedResult: DataProviderResult, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "wait for load completion")

        sut.load()
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
            .store(in: &cancellables)

        action()

        wait(for: [exp], timeout: 1.0)
    }

    func failure(_ error: DataProvider.NetworkError) -> DataProviderResult {
        .failure(error)
    }

    func makeResponse() -> (model: Response, json: [String: Any]) {
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

    func makeItemsJSON(_ items: [[String: Any]]) -> Data {
        try! JSONSerialization.data(withJSONObject: ["categories": items])
    }

    func anyURLError() -> URLError {
        URLError(.unknown)
    }
}
