//
//  ICURLRequest.swift
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/16/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

import UIKit

class ICURLRequest: NSObject {
    
    // MARK: Proeprties
    
    private(set) var urlRequest: URLRequest!
    
    
    // MARK: Initializers

    init(body: Data) {
        super.init()
        
        self.urlRequest            = URLRequest(url: URL(string: ICUrls.api)!)
        self.urlRequest.httpMethod = httpMethod.post
        self.urlRequest.httpBody   = body
        
        self.urlRequest.addValue(ICConstants.urlEncodedContentType, forHTTPHeaderField: ICConstants.contentType)
    }
}
