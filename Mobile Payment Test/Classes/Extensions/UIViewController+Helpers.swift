//
//  UIViewController+Helpers.swift
//  Mobile Payment Test
//
//  Created by Valio Cholakov on 6/12/18.
//  Copyright © 2018 Intercard Finance AD. All rights reserved.
//

import Foundation

extension UIViewController {
    
    var presenter: UIViewController {
        return self.navigationController ?? self
    }
}
