//
//  ICOrderTableViewCell.swift
//  Mobile Payment Test
//
//  Created by Valio Cholakov on 1/16/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

import UIKit

class ICOrderTableViewCell: ICBaseTableViewCell {

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
