//
//  ICCardTableViewCell.swift
//  Mobile Payment Test
//
//  Created by Valio Cholakov on 1/16/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

import UIKit

class ICCardTableViewCell: ICBaseTableViewCell {
    
    // MARK: Properties
    
    var card: ICCard? {
        didSet {
            self.setData()
        }
    }
    

    // MARK: Private Methods

    private func setData() {
        guard let card = self.card else {
            return
        }
        
        self.titleLabel.text = "\(card.name) - \(card.token)"
    }
}
