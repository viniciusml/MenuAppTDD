//
//  MenuAppTDDAPIEndToEndTests.swift
//  MenuAppTDDAPIEndToEndTests
//
//  Created by Vinicius Moreira Leal on 09/05/2020.
//  Copyright © 2020 Vinicius Leal and Gabriel Meira. All rights reserved.
//

import XCTest
import MenuAppTDD
import Combine

class MenuAppTDDAPIEndToEndTests: XCTestCase {

    func test_endToEndServerGETCategories_matchesFixedTestData() {
        let categories = getCategories()?.categories

        XCTAssertEqual(categories?.count, 13)

        categories?.enumerated().forEach { (index, item) in
            XCTAssertEqual(item.categories, expectedCategory(at: index))
        }
    }

    // MARK: - Helpers

    private func getCategories(file: StaticString = #file, line: UInt = #line) -> Response? {
        let requestBuilder = URLRequestBuilder(urlString: URLRequestConstant.baseURL,
                                               headers: URLRequestConstant.defaultHeaders)
        let request = requestBuilder.buildRequest(for: URLRequestConstant.categoriesEndpoint)

        let client = URLSessionHTTPClient()
        let dataProvider = DataProvider(request: request, client: client)

        trackForMemoryLeaks(client, file: file, line: line)

        let exp = expectation(description: "Wait for load completion")

        var receivedResult: Response?
        var sub: Cancellable? = nil
        let publisher = dataProvider.load()

        sub = publisher
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                exp.fulfill()
            }, receiveValue: { [weak self] value in
                guard self != nil else { return }

                receivedResult = value
                exp.fulfill()
            })

        wait(for: [exp], timeout: 5.0)
        XCTAssertNotNil(sub)

        return receivedResult
    }

    private func expectedCategory(at index: Int) -> Categories {
        Categories(id: id(at: index), name: name(at: index))
    }

    private func id(at index: Int) -> Int {
        [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14][index]
    }

    private func name(at index: Int) -> String {
        ["Delivery",
         "Dine-out",
         "Nightlife",
         "Catching-up",
         "Takeaway",
         "Cafes",
         "Daily Menus",
         "Breakfast",
         "Lunch",
         "Dinner",
         "Pubs & Bars",
         "Pocket Friendly Delivery",
         "Clubs & Lounges"][index]
    }
}
