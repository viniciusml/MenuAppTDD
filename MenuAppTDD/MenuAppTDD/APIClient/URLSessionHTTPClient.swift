//
//  URLSessionHTTPClient.swift
//  MenuAppTDD
//
//  Created by Vinicius Moreira Leal on 12/04/2020.
//  Copyright © 2020 Vinicius Leal and Gabriel Meira. All rights reserved.
//

import Foundation

public class URLSessionHTTPClient: DataTaskPublisher {
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func createPublisher(from request: URLRequest) -> URLSession.DataTaskPublisher {
        return session.dataTaskPublisher(for: request)
    }
}
