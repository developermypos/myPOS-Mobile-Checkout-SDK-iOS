//
//  MPTransactionTableViewCell.swift
//  Mobile Payment Test
//
//  Created by Valio Cholakov on 1/16/17.
//  Copyright © 2020 myPOS AD. All rights reserved.
//

import UIKit

class MPTransactionTableViewCell: MPBaseTableViewCell {

    // MARK: Properties
    
    var transaction: MPTransaction? {
        didSet {
            self.setData()
        }
    }
    
    
    // MARK: Private Methods
    
    private func setData() {
        guard let transaction = self.transaction else {
            return
        }
        
        self.titleLabel.text = "Order - \(transaction.orderId)\nRef.№. - \(transaction.reference)"
    }
}
