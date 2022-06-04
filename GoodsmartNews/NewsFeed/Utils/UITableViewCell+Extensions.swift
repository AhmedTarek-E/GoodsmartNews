//
//  UITableViewCell+Extensions.swift
//  GoodsmartNews
//
//  Created by Ahmed Tarek on 04/06/2022.
//

import UIKit

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell {
    static var identifier: String {
        return className
    }
    
    static var className: String {
        return String(describing: self)
    }
}
