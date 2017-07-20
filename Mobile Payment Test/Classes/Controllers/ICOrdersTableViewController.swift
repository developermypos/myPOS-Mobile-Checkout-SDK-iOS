//
//  ICOrdersTableViewController.swift
//  Mobile Payment Test
//
//  Created by Valio Cholakov on 1/16/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

import UIKit
import MobilePaymentSDK

class ICOrdersTableViewController: ICBaseTableViewController {

    // MARK: Constants
    
    private let kCellIdentifier = "order"
    
    
    // MARK: Variables
    
    private var _orders: [String] = ICUtils.orders
    
    
    // MARK: Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _orders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier, for: indexPath)
        
        if let orderCell = cell as? ICOrderTableViewCell {
            orderCell.order = _orders[indexPath.row]
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    // MARK: Table View Delegate
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        self.askForOrderType(_orders[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let orderToDelete = _orders[indexPath.row]
        
        guard let orderIndexToDelete = _orders.index(of: orderToDelete) else {
            return
        }
        
        _orders.remove(at: orderIndexToDelete)
        UserDefaults.deleteOrder(orderToDelete)
        
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    
    // MARK: Private Methods
    
    private func askForOrderType(_ orderId: String) {
        let alertController = UIAlertController(title: "Select order type", message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let purchaseAction = UIAlertAction(title: "Purchase", style: .default) { (_) in
            self.getOrderStatus(orderId, type: .purchase)
        }
        
        let refundAction = UIAlertAction(title: "Refund", style: .default) { (_) in
            self.getOrderStatus(orderId, type: .refund)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(refundAction)
        alertController.addAction(purchaseAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func getOrderStatus(_ orderId: String, type: TransactionType) {
        self.showLoadingHUD()
        
        MobilePaymentSDK.getOrderStatus(orderId,
                                        transactionType: type,
                                        completion: { (status, reference) in
                                            self.hideLoadingHUD()
                                            self.showAlertWithText("Order \(orderId). " +
                                                "Status - \(status) | Reference - \(reference)")
        },
                                        failure: { (error) in
                                            self.showAlertWithText("Error while getting order status: \(error.localizedDescription)")
                                            self.hideLoadingHUD()
        })
    }
}
