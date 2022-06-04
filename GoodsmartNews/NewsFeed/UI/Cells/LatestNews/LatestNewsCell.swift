//
//  LatestNewsCell.swift
//  GoodsmartNews
//
//  Created by Ahmed Tarek on 04/06/2022.
//

import UIKit
import PINRemoteImage

class LatestNewsCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    private func setupView() {
        articleImageView.clipsToBounds = true
        articleImageView.layer.cornerRadius = 8
    }
    
    func bind(article: Article) {
        titleLabel.text = article.title
        articleImageView.pin_setImage(from: URL(string: article.image))
    }

}
