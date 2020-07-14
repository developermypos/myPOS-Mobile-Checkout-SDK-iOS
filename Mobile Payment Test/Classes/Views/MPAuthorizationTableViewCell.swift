//
//  MPAuthorizationTableViewCell.swift
//  Mobile Payment Test
//
//  Created by Valio Cholakov on 13.07.20.
//  Copyright © 2020 myPOS AD. All rights reserved.
//

import UIKit

class MPAuthorizationTableViewCell: MPBaseTableViewCell {
    
    // MARK: - Variables
    
    var authorization: MPAuthorization? {
        didSet {
            self.setData()
        }
    }
    
    
    // MARK: - Private Methods
    
    private func setData() {
        guard let authorization = self.authorization else {
            return
        }
        
        self.titleLabel.text = authorization.orderId
    }
}
