//
//  MenuMainView.swift
//  MenuAppTDD
//
//  Created by Vinicius Moreira Leal on 13/01/2020.
//  Copyright © 2020 Vinicius Leal and Gabriel Meira. All rights reserved.
//

import SwiftUI

struct MenuMainView: View {
    
    let tvAppearance = UITableView.appearance()
    
    init() {
        tvAppearance.backgroundColor = .clear
        tvAppearance.separatorColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.appRed)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: UIScreen.main.whiteThirds(1.0)))
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    HStack {
                        Text("Salads \nmenu")
                            .font(.custom(String.mainFont, size: 36))
                            .foregroundColor(Color(.white))
                            .multilineTextAlignment(.leading)
                            .padding(.leading, 45)
                        Spacer()
                    }
                    Spacer(minLength: 60)
                    Form {
                        MenuCellView()
                            .listRowInsets(EdgeInsets(top: 0, leading: 30, bottom: 30, trailing: 30))
                            .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.trailing)
                    .padding(.leading)
                    .padding(.top, -20)
                    .padding(.bottom)
                    .edgesIgnoringSafeArea(.all)
                }
            }
                //Change menu to arrow
                .navigationBarItems(
                    leading: MenuButton(color: .white),
                    trailing: NavigationItem("basket", color: .appNavItemColor))
        }
    }
}

struct MenuCellView: View {
    var body: some View {
        HStack {
            ZStack {
                Color(.white)
                    .frame(height: CGFloat.CellHeight.menuCollapsed)
                    .cornerRadius(16)
                    .shadow(radius: 7)
                HStack {
                    DishViewT()
                        .padding(.leading, -30)
                    VStack {
                        HStack {
                            Text("Fried rice with egg and onions")
                                .font(.custom("TimesNewRomanPSMT", size: 18))
                                .foregroundColor(Color(.black))
                            Spacer()
                        }
                        // Stars
                        HStack {
                            Color(.black)
                                .frame(height: 20)
                            Spacer(minLength: 80)
                        }
                        HStack {
                            Text("300 g")
                                .font(.custom("TimesNewRomanPSMT", size: 16))
                                .foregroundColor(Color(.secondaryLabel))
                            Spacer()
                            RedText("3.99", size: 16)
                            RedText("£", size: 12)
                                .padding(EdgeInsets(top: -5, leading: -5, bottom: 0, trailing: 0))
                        }
                    }
                    .padding(.leading)
                    Spacer()
                    // Plus Sign
                    AccessoryView()
                        .padding(.trailing, -20)
                }
            }
        }
    }
}

struct RedText: View {
    
    let text: String
    let size: CGFloat
    
    init(_ text: String, size: CGFloat) {
        self.text = text
        self.size = size
    }
    
    var body: some View {
        Text(text)
            .font(.custom("Verdana", size: size))
            .foregroundColor(Color(.appRed))
    }
}

struct DishViewT: View {
    var body: some View {
        Color(.white)
            .frame(width: 100, height: 100)
            .cornerRadius(25)
            .shadow(radius: 4)
    }
}

struct AccessoryViewT: View {
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

struct MenuMainView_Previews: PreviewProvider {
    static var previews: some View {
        MenuMainView()
    }
}
