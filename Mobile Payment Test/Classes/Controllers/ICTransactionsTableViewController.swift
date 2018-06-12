//
//  ICTransactionsTableViewController.swift
//  Mobile Payment Test
//
//  Created by Valio Cholakov on 1/16/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

import UIKit
import MobilePaymentSDK

class ICTransactionsTableViewController: ICBaseTableViewController {

    // MARK: Constants
    
    private let kCellIdentifier = "transaction"
    
    
    // MARK: Variables
    
    private var _transactions: [ICTransaction] = ICUtils.transactions
    private var _selectedIndexPath: IndexPath?
    
    
    // MARK: Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _transactions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier, for: indexPath)
        
        if let transactionCell = cell as? ICTransactionTableViewCell {
            transactionCell.transaction = _transactions[indexPath.row]
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let oldIndexPath = _selectedIndexPath {
            if let oldSelectedCell = tableView.cellForRow(at: oldIndexPath) {
                oldSelectedCell.accessoryType = .none
            }
        }
        
        _selectedIndexPath = _selectedIndexPath != indexPath ? indexPath : nil
        let cellIsSelected = _selectedIndexPath != nil
        
        self.navigationItem.rightBarButtonItem?.isEnabled = cellIsSelected
        
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = cellIsSelected ? .checkmark : .none
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let transactionToDelete = _transactions[indexPath.row]
        
        guard let transactionIndexToDelete = _transactions.index(of: transactionToDelete) else {
            return
        }
        
        _transactions.remove(at: transactionIndexToDelete)
        UserDefaults.deleteTransaction(transactionToDelete)
        
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    
    // MARK: Actions
    
    @IBAction func refund(_ sender: UIBarButtonItem) {
        guard let selectedIndexPath = _selectedIndexPath else {
            sender.isEnabled = false
            return
        }
        
        self.refundTransaction(_transactions[selectedIndexPath.row])
    }
    
    
    // MARK: Private Methods
    
    private func refundTransaction(_ transaction: ICTransaction) {
        var amountTextField: UITextField?
        let alertController = UIAlertController(title: "Refund",
                                                message: "Please enter the amount you would like to refund",
                                                preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder  = "Enter amount"
            textField.keyboardType = .decimalPad
            
            amountTextField = textField
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let refundAction = UIAlertAction(title: "Refund", style: .default) { (_) in
            let rawAmount = (amountTextField?.text ?? "").replacingOccurrences(of: ",", with: ".")
            
            if rawAmount.components(separatedBy: ".").count > 2 {
                self.showAlertWithText("Please enter a valid amount")
                return
            }
            
            let amount = (rawAmount as NSString).doubleValue
            
            self.showLoadingHUD()
            
            MobilePaymentSDK.refundTransaction(transaction.reference, fromOrder: transaction.orderId, amount: CGFloat(amount), completion: { (transactionRef) in
                self.hideLoadingHUD()
                self.showAlertWithText("Refund completed successfully", popToRoot: true)
            }, failure: { (error) in
                self.hideLoadingHUD()
                self.showAlertWithText("Refund failed. Error: \(error.localizedDescription)")
            })
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(refundAction)
        
        self.presenter.present(alertController, animated: true, completion: nil)
    }
}
