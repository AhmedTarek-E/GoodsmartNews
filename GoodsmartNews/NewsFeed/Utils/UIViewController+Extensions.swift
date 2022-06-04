//
//  UIViewController+Extensions.swift
//  GoodsmartNews
//
//  Created by Ahmed Tarek on 04/06/2022.
//

import UIKit

extension UIViewController {
    func showError(error: String) {
        let alert = UIAlertController(
            title: "Error",
            message: error,
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(title: "Ok", style: .default)
        )
        present(alert, animated: true)
    }
}
