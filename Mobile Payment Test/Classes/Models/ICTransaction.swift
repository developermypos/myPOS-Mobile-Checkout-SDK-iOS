//
//  ICTransaction.swift
//  Mobile Payment Test
//
//  Created by Valio Cholakov on 1/16/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

import UIKit

class ICTransaction: NSObject, NSCoding {

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
        self.orderId  = aDecoder.decodeObject(forKey:  ICConstants.orderId)   as! String
        self.reference = aDecoder.decodeObject(forKey: ICConstants.reference) as! String
    }
    
    
    // MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.orderId,   forKey: ICConstants.orderId)
        aCoder.encode(self.reference, forKey: ICConstants.reference)
    }
    
    
    // MARK: NSObject
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let transaction = object as? ICTransaction else {
            return false
        }
        
        return transaction.reference == self.reference
    }
}
