//
//  HTTPClient.swift
//  MenuAppTDD
//
//  Created by Vinicius Moreira Leal on 23/03/2020.
//  Copyright © 2020 Vinicius Leal and Gabriel Meira. All rights reserved.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL) -> Result<[CategoryItem], Error>
}
