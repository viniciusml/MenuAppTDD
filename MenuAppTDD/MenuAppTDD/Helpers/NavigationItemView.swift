//
//  NavigationItemView.swift
//  MenuAppTDD
//
//  Created by Vinicius Moreira Leal on 23/01/2020.
//  Copyright © 2020 Vinicius Leal and Gabriel Meira. All rights reserved.
//

import SwiftUI

struct NavigationItem: View {
    var image: String
    var color: UIColor
    
    init(_ image: String, color: UIColor) {
        self.image = image
        self.color = color
    }
    
    var body: some View {
        Image(image)
            .resizable()
            .frame(width: 30, height: 30)
            .foregroundColor(Color(color))
    }
}
