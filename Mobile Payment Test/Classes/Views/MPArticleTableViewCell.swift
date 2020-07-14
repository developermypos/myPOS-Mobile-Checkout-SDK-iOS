//
//  MPArticleTableViewCell.swift
//  Mobile Payment Test
//
//  Created by Valio Cholakov on 1/16/17.
//  Copyright © 2020 myPOS AD. All rights reserved.
//

import UIKit

class MPArticleTableViewCell: MPBaseTableViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var amountLabel: UILabel!
    
    
    // MARK: Properties
    
    var cartItem: MPCartItem? {
        didSet {
            self.setData()
        }
    }
    
    
    // MARK: Private Methods
    
    private func setData() {
        guard let cartItem = self.cartItem else {
            return
        }
        
        self.titleLabel.text  = cartItem.name
        self.amountLabel.text = "\(cartItem.quantity) x \(cartItem.price)"
    }
}
