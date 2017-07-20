//
//  ICArticleTableViewCell.swift
//  Mobile Payment Test
//
//  Created by Valio Cholakov on 1/16/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

import UIKit

class ICArticleTableViewCell: ICBaseTableViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var amountLabel: UILabel!
    
    
    // MARK: Properties
    
    var cartItem: CartItem? {
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
