//
//  ICCard.swift
//  Mobile Payment Test
//
//  Created by Valio Cholakov on 1/16/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

import UIKit

class ICCard: NSObject, NSCoding {
    
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
        self.name  = aDecoder.decodeObject(forKey: ICConstants.name)  as! String
        self.token = aDecoder.decodeObject(forKey: ICConstants.token) as! String
    }
    
    
    // MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name,  forKey: ICConstants.name)
        aCoder.encode(self.token, forKey: ICConstants.token)
    }
    
    
    // MARK: NSObject
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let card = object as? ICCard else {
            return false
        }
        
        return card.token == self.token
    }
}
