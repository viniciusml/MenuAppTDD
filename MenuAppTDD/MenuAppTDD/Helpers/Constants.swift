//
//  Constants.swift
//  MenuAppTDD
//
//  Created by Vinicius Moreira Leal on 07/12/2019.
//  Copyright © 2019 Vinicius Leal and Gabriel Meira. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    static let appRed = UIColor(hex: "F53B50")
}

extension CGFloat {
    
    struct CellHeight {
        
        static let category = 108
        
        static let menuCollapsed = 138
        
        static let menuExpanded = 428
        
        static let shoppingCart = 143
    }
    
    struct CardHeight {
        
        static let collapsed = 80
        
        static let expanded = 375
    }
}

extension UIFont {
    private static func customFont(name: String, size: CGFloat) -> UIFont {
        let font = UIFont(name: name, size: size)
        assert(font != nil, "Can't load font: \(name)")
        return font ?? UIFont.systemFont(ofSize: size)
    }
    
    static func mainFont(ofSize size: CGFloat) -> UIFont {
        return customFont(name: "Ultra-Regular", size: size)
    }
}
