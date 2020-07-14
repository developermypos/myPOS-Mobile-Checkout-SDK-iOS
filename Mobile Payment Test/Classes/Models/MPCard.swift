//
//  MPCard.swift
//  Mobile Payment Test
//
//  Created by Valio Cholakov on 1/16/17.
//  Copyright © 2020 myPOS AD. All rights reserved.
//

import UIKit

class MPCard: NSObject, NSCoding {
    
    // MARK: Propeties
    
    private(set) var name: String  = ""
    private(set) var token: String = ""

    
    // MARK: Initializers
    
    init(name: String, token: String) {
        super.init()
        
        self.name  = name
        self.token = token
    }
    
    required init(coder aDecoder: NSCoder) {
        self.name  = aDecoder.decodeObject(forKey: MPConstants.name)  as! String
        self.token = aDecoder.decodeObject(forKey: MPConstants.token) as! String
    }
    
    
    // MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name,  forKey: MPConstants.name)
        aCoder.encode(self.token, forKey: MPConstants.token)
    }
    
    
    // MARK: NSObject
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let card = object as? MPCard else {
            return false
        }
        
        return card.token == self.token
    }
}
