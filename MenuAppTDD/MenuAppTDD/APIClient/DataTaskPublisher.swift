//
//  DataTaskPublisher.swift
//  MenuAppTDD
//
//  Created by Vinicius Moreira Leal on 23/03/2020.
//  Copyright © 2020 Vinicius Leal and Gabriel Meira. All rights reserved.
//

import Foundation

public protocol DataTaskPublisher {
    func createPublisher(from request: URLRequest) -> URLSession.DataTaskPublisher
}
