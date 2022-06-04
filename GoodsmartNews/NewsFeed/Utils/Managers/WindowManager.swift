//
//  WindowManager.swift
//  GoodsmartNews
//
//  Created by Ahmed Tarek on 04/06/2022.
//

import UIKit

enum WindowManager {
    static func configure() {
        window.makeKeyAndVisible()
        window.rootViewController = UINavigationController(
            rootViewController: NewsFeedViewController.create()
        )
    }
}

extension WindowManager {
    static var window: UIWindow {
        if let window = AppDelegate.shared.window {
            return window
        } else {
            AppDelegate.shared.window = UIWindow(frame: UIScreen.main.bounds)
            return AppDelegate.shared.window!
        }
    }
}
