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
        
    static let appDarkBlue = UIColor(hex: "313B52")
    
    static let appNavItemColor = UIColor(hex: "E3E1E1")
}

extension CGFloat {
    
    struct CellHeight {
        
        static let category: CGFloat = 108
        
        static let menuCollapsed: CGFloat = 138
        
        static let menuExpanded: CGFloat = 428
        
        static let shoppingCart: CGFloat = 143
    }
    
    struct CardHeight {
        
        static let collapsed: CGFloat = 80
        
        static let expanded: CGFloat = UIScreen.main.bounds.height * 0.45
    }
}

extension String {
    
    static let mainFont = "Ultra-Regular"
}
