//
//  URLRequestConstants.swift
//  MenuAppTDD
//
//  Created by Vinicius Moreira Leal on 13/04/2020.
//  Copyright © 2020 Vinicius Leal and Gabriel Meira. All rights reserved.
//

import Foundation

public struct URLRequestConstant {
    public static let baseURL = "https://developers.zomato.com/api/v2.1"
    
    public static let defaultHeaders: [String: String] = [
        "Content-Type": "application/json",
        "user-key": "d25a516a7a59fb465b3b1440a2c92621"
    ]
    
    public static let categoriesEndpoint: Endpoint = "/categories"
}
