//
//  MPCardTableViewCell.swift
//  Mobile Payment Test
//
//  Created by Valio Cholakov on 1/16/17.
//  Copyright © 2020 myPOS AD. All rights reserved.
//

import UIKit

class MPCardTableViewCell: MPBaseTableViewCell {
    
    // MARK: Properties
    
    var card: MPCard? {
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
