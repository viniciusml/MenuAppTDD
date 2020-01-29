//
//  CategoryMainView.swift
//  MenuAppTDD
//
//  Created by Vinicius Moreira Leal on 13/01/2020.
//  Copyright © 2020 Vinicius Leal and Gabriel Meira. All rights reserved.
//

import SwiftUI

struct CategoryMainView: View {
    
    let tvAppearance = UITableView.appearance()
    
    init(){
        tvAppearance.backgroundColor = .clear
        tvAppearance.separatorColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.appRed)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: UIScreen.main.whiteThirds(2.0)))
                    .edgesIgnoringSafeArea(.all)
                Form {
                    ForEach(1...10, id: \.self) {_ in
                        
                      CategoryView()
                      .listRowInsets(EdgeInsets(top: 0, leading: 30, bottom: 30, trailing: 30))

                      .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.trailing)
                .padding(.leading)
                .padding(.top, -20)
                .padding(.bottom)
                .edgesIgnoringSafeArea(.all)
            }
            .navigationBarItems(
                leading: NavigationItem("menu", color: .white),
                trailing: NavigationItem("basket", color: .appNavItemColor))
        }
    }
}

struct CategoryView: View {
    var body: some View {
        HStack {
            CellView()
        }
    }
}

struct CellView: View {
    var body: some View {
        HStack {
            ZStack {
                Color(.white)
                    .frame(height: CGFloat.CellHeight.category)
                    .cornerRadius(16)
                    .shadow(radius: 7)
                HStack {
                    DishView()
                        .padding(.leading, -30)
                    VStack {
                        HStack {
                            Text("Desserts")
                                .font(.custom(String.mainFont, size: 24))
                                .foregroundColor(Color(.appDarkBlue))
                            Spacer()
                        }
                        HStack {
                            Text("30 items")
                                .font(.custom("Verdana", size: 15))
                                .foregroundColor(Color(.secondaryLabel))
                            Spacer()
                        }
                    }
                    .padding(.leading)
                    Spacer()
                    AccessoryView()
                        .padding(.trailing, -20)
                }
            }
        }
    }
}

struct DishView: View {
    var body: some View {
        Color(.white)
            .frame(width: 74, height: 74)
            .cornerRadius(37)
            .shadow(radius: 4)
    }
}

struct AccessoryView: View {
    var body: some View {
        Button(action: {
            print("Accessory tapped")
        }) {
            ZStack {
                Color(.white)
                    .frame(width: 40, height: 40, alignment: .trailing)
                    .cornerRadius(20)
                    .shadow(radius: 4)
                Image("chevron")
                    .resizable()
                    .foregroundColor(Color(.appRed))
                    .frame(width: 20, height: 20, alignment: .center)
                    .padding(.leading, 3)
                
            }
        }
        
    }
}

struct CategoryMainView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryMainView()
    }
}


