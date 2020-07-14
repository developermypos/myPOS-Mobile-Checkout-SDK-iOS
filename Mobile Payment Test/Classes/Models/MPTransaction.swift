//
//  MPTransaction.swift
//  Mobile Payment Test
//
//  Created by Valio Cholakov on 1/16/17.
//  Copyright © 2020 myPOS AD. All rights reserved.
//

import UIKit

class MPTransaction: NSObject, NSCoding {

    // MARK: Properties
    
    private(set) var orderId: String = ""
    private(set) var reference: String = ""
    
    
    // MARK: Initializers
    
    init(orderId: String, reference: String) {
        super.init()
        
        self.orderId   = orderId
        self.reference = reference
    }
    
    
    required init(coder aDecoder: NSCoder) {
        self.orderId  = aDecoder.decodeObject(forKey:  MPConstants.orderId)   as! String
        self.reference = aDecoder.decodeObject(forKey: MPConstants.reference) as! String
    }
    
    
    // MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.orderId,   forKey: MPConstants.orderId)
        aCoder.encode(self.reference, forKey: MPConstants.reference)
    }
    
    
    // MARK: NSObject
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let transaction = object as? MPTransaction else {
            return false
        }
        
        return transaction.reference == self.reference
    }
}
