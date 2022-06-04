//
//  MoreNewsCell.swift
//  GoodsmartNews
//
//  Created by Ahmed Tarek on 04/06/2022.
//

import UIKit

class MoreNewsCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bind(article: Article) {
        titleLabel.text = article.title
        descriptionLabel.text = article.description
        articleImageView.pin_setImage(from: URL(string: article.image))
        dateLabel.text = article.formattedDate
    }

}

extension Article {
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d/M/yy h:mm a"
        return formatter.string(from: publishedAt)
    }
}
