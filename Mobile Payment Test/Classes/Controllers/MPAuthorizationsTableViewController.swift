//
//  MPAuthorizationsTableViewController.swift
//  Mobile Payment Test
//
//  Created by Valio Cholakov on 13.07.20.
//  Copyright © 2020 myPOS AD. All rights reserved.
//

import UIKit

class MPAuthorizationsTableViewController: MPBaseTableViewController {
    
    // MARK: - Constants
    
    private let kCellIdentifier = "authorization"
    
    //MARK: - Variables
    
    private var _authorizations: [MPAuthorization] = []
    
    
    //MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.showLoadingHUD()
        MPCheckout.listAuthorizations(completion: { [weak self] (authorizations) in
            self?.hideLoadingHUD()
            self?._authorizations = authorizations
            self?.tableView.reloadData()
        }) { (error) in
            self.hideLoadingHUD()
            NSLog("Failed to get authorizations: %@", error.localizedDescription)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _authorizations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier, for: indexPath)

        if let authorizationCell = cell as? MPAuthorizationTableViewCell {
            authorizationCell.authorization = _authorizations[indexPath.row]
        }

        return cell
    }

    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let authorization = _authorizations[indexPath.row]
        let alertController = UIAlertController(
            title: "Authorization \(authorization.orderId)",
            message: "Amount: \(authorization.amount)\nCurrency: \(authorization.currency)\nTransaction reference: \(authorization.trnReference)\nExpiry date: \(authorization.date)",
            preferredStyle: .actionSheet
        )
        
        alertController.addAction(UIAlertAction(title: "Capture \(authorization.amount) \(authorization.currency)", style: .default, handler: { (_) in
            self.showLoadingHUD()
            MPCheckout.captureAuthorization(authorization.orderId, forAmount: CGFloat(Float(authorization.amount) ?? 0.00), completion: { (_) in
                self.showSuccessMessage()
            }) { (error) in
                self.hideLoadingHUD()
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Reverse", style: .default, handler: { (_) in
            self.showLoadingHUD()
            MPCheckout.cancelAuthorization(authorization.orderId, completion: { (_) in
                self.showSuccessMessage()
            }) { (error) in
                self.hideLoadingHUD()
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Close", style: .cancel, handler: { (_) in
            tableView.deselectRow(at: indexPath, animated: true)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func showSuccessMessage() {
        self.hideLoadingHUD()
        let alert = UIAlertController(title: "myPOS", message: "Operation completed successfully", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: { [weak self] (_) in
            self?.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
