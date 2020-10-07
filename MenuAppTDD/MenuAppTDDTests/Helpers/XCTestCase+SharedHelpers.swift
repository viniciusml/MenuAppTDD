//
//  XCTestCase+SharedHelpers.swift
//  MenuAppTDDTests
//
//  Created by Vinicius Leal on 07/10/2020.
//  Copyright © 2020 Vinicius Leal and Gabriel Meira. All rights reserved.
//

import XCTest

extension XCTestCase {
    func nonHTTPURLResponse() -> URLResponse {
        URLResponse(url: anyURLRequest().url!, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
    }

    func anyURLRequest() -> URLRequest {
        return URLRequest(url: anyURL())
    }

    func anyData() -> Data {
        Data("any Data".utf8)
    }

    func anyURL() -> URL {
        return URL(string: "http://any-url.com")!
    }
}
