//
//  NewsFeedHeaderView.swift
//  GoodsmartNews
//
//  Created by Ahmed Tarek on 04/06/2022.
//

import UIKit

class NewsFeedHeaderView: UICollectionReusableView {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bind(title: String) {
        titleLabel.text = title
    }
}
