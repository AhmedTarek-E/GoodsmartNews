//
//  StockTickerCell.swift
//  GoodsmartNews
//
//  Created by Ahmed Tarek on 04/06/2022.
//

import UIKit

class StockTickerCell: UICollectionViewCell {
    @IBOutlet weak var stockNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func bind(stock: StockTicker) {
        stockNameLabel.text = stock.name
        priceLabel.text = stock.formattedValue
        priceLabel.textColor = stock.valueColor
    }
}

extension StockTicker {
    var formattedValue: String {
        let trimmed = Double(Int(value*100))/100.0
        return "\(trimmed) USD"
    }
    
    var valueColor: UIColor {
        if value > 0 {
            return .green
        } else if value < 0 {
            return .red
        } else {
            return .blue
        }
    }
}
