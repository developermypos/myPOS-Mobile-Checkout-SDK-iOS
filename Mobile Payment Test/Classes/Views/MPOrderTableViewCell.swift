//
//  MPOrderTableViewCell.swift
//  Mobile Payment Test
//
//  Created by Valio Cholakov on 1/16/17.
//  Copyright © 2020 myPOS AD. All rights reserved.
//

import UIKit

class MPOrderTableViewCell: MPBaseTableViewCell {

    // MARK: Properties
    
    var order: String? {
        didSet {
            self.setData()
        }
    }
    
    
    // MARK: Private Methods
    
    private func setData() {
        guard let order = self.order else {
            return
        }
        
        self.titleLabel.text = order
    }
}
