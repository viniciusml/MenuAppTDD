//
//  HTTPClientStub.swift
//  MenuAppTDDTests
//
//  Created by Vinicius Moreira Leal on 19/05/2020.
//  Copyright © 2020 Vinicius Leal and Gabriel Meira. All rights reserved.
//

import Combine
import Foundation
import MenuAppTDD

class HTTPClientStub: DataTaskPublisher {

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
