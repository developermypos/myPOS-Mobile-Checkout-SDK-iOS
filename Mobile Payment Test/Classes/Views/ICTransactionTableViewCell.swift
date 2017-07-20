//
//  ICTransactionTableViewCell.swift
//  Mobile Payment Test
//
//  Created by Valio Cholakov on 1/16/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

import UIKit

class ICTransactionTableViewCell: ICBaseTableViewCell {

    // MARK: Properties
    
    var transaction: ICTransaction? {
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
