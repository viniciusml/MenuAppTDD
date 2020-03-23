//
//  Category.swift
//  MenuAppTDD
//
//  Created by Vinicius Moreira Leal on 10/02/2020.
//  Copyright © 2020 Vinicius Leal and Gabriel Meira. All rights reserved.
//

import Foundation

public struct CategoryItem: Codable {
    let categoryID: String
    let categoryName: String

    public init(categoryID: String, categoryName: String) {
        self.categoryID = categoryID
        self.categoryName = categoryName
    }
}
