//
//  MenuAnimation.swift
//  MenuAppTDD
//
//  Created by Vinicius Moreira Leal on 19/04/2020.
//  Copyright © 2020 Vinicius Leal and Gabriel Meira. All rights reserved.
//

import SwiftUI

fileprivate struct MenuButtonView: View {

    var body: some View {
        MenuButton(color: .red)
            .frame(width: 20, height: 20, alignment: .center)
    }
}

public struct MenuButton: View {
    
    var color: UIColor
    @State private var isAnimating: Bool = false
    
    public var body: some View {
        Button(action: {
            self.isAnimating.toggle()
        }, label: {
            createMenu()
                .foregroundColor(Color(color))
                .frame(width: 20, height: 20)
        })
    }

    func createMenu() -> AnyView {
        let count = 4
        let indicator = GeometryReader { (geometry: GeometryProxy) in
            ForEach(0..<count) { index in
                Group { () -> AnyView in
                    let availableHeight = geometry.size.height / CGFloat(count)
                    let spacing = availableHeight / 3
                    let height = availableHeight - spacing
                    let width = geometry.size.width

                    let rect = RoundedRectangle(cornerRadius: 2)
                        .frame(width: width, height: height)
                    return AnyView(
                        rect
                            .offset(y: availableHeight * CGFloat(index))
                            .offset(x: self.remove(index))
                            .opacity(self.fade(index))
                            .rotationEffect(self.rotate(index))
                            .offset(x: self.offset(index, xValue: width / 4, yValue: spacing).x,
                                    y: self.offset(index, xValue: width / 4, yValue: spacing).y)
                            .animation(
                                Animation.easeInOut
                                    .delay(0.2)
                            )
                    )
                }
            }
        }
        return AnyView(indicator)
    }
    
    private func offset(_ rect: Int, xValue: CGFloat, yValue: CGFloat) -> (x: CGFloat, y: CGFloat) {
        let condition = validateMiddle(rect)
        var offsetX: CGFloat = 0.0
        var offsetY: CGFloat = 0.0
        
        switch rect {
        case 1:
            offsetX = condition ? xValue : 0.0
            offsetY = condition ? yValue : 0.0
        case 2:
            offsetX = condition ? -xValue : 0.0
            offsetY = condition ? -yValue : 0.0
        default: break
        }
        
        return (offsetX, offsetY)
    }

    private func rotate(_ rect: Int) -> Angle {
        let condition = validateMiddle(rect)
        var degrees: Double = 0.0

        switch rect {
        case 1:
            degrees = condition ? 45.0 : 0.0
        case 2:
            degrees = condition ? -45.0 : 0.0
        default: degrees = 0.0
        }
        return Angle(degrees: degrees)
    }

    private func fade(_ rect: Int) -> Double {
        let condition = validateMargin(rect)
        switch rect {
        case 0:
            return condition ? 0.0 : 1.0
        case 3:
            return condition ? 0.0 : 1.0
        default: return 1
        }
    }

    private func remove(_ rect: Int) -> CGFloat {
        let condition = validateMargin(rect)
        switch rect {
        case 0:
            return condition ? 20 : 0
        case 3:
            return condition ? -20 : 0
        default: return 0
        }
    }

    private func validateMargin(_ rect: Int) -> Bool {
        (rect == 0 || rect == 3) && isAnimating
    }

    private func validateMiddle(_ rect: Int) -> Bool {
        (rect == 1 || rect == 2) && isAnimating
    }
}

#if DEBUG
    struct MenuAnimation_Previews: PreviewProvider {
        static var previews: some View {
            MenuButtonView()
                .previewLayout(.fixed(width: 100, height: 100))
        }
    }
#endif
