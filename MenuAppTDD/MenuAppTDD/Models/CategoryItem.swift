//
//  Category.swift
//  MenuAppTDD
//
//  Created by Vinicius Moreira Leal on 10/02/2020.
//  Copyright © 2020 Vinicius Leal and Gabriel Meira. All rights reserved.
//

import Foundation

// MARK: - Response
public struct Response: Codable, Equatable {
    let categories: [Category]
    
    public init(categories: [Category]) {
        self.categories = categories
    }
}

// MARK: - Category
public struct Category: Codable, Equatable {
    let categories: Categories
    
    public init(categories: Categories) {
        self.categories = categories
    }
}

// MARK: - Categories
public struct Categories: Codable, Equatable {
    let id: Int
    let name: String
    
    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
