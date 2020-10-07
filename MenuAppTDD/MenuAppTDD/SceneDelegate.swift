//
//  SceneDelegate.swift
//  MenuAppTDD
//
//  Created by Vinicius Moreira Leal on 01/12/2019.
//  Copyright © 2019 Vinicius Moreira Leal. All rights reserved.
//

import SwiftUI
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = UIHostingController(rootView: ContentView())
        window?.makeKeyAndVisible()
    }
}

struct ContentView: View {
    var body: some View {
        Text("MenuApp")
    }
}
