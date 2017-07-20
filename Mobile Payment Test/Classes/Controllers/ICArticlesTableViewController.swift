//
//  ICArticlesTableViewController.swift
//  Mobile Payment Test
//
//  Created by Valio Cholakov on 1/16/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

import UIKit
import MobilePaymentSDK

class ICArticlesTableViewController: ICBaseTableViewController {
    
    // MARK: Constants
    
    private let kCardsSegue     = "cards"
    private let kCellIdentifier = "article"
    
    
    // MARK: Variables
    
    private var orderId: String?
    private var _cartItems: [CartItem] = []
    private var _selectedItems: [CartItem] = []
    

    // MARK: Controller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setArticles()
    }

    
    // MARK: - Table View Data Source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _cartItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier, for: indexPath)
        
        if let articleCell = cell as? ICArticleTableViewCell {
            articleCell.cartItem = _cartItems[indexPath.row]
        }

        return cell
    }
    
    
    // MARK: Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCell = tableView.cellForRow(at: indexPath) else {
            return
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let seelctedArticle = _cartItems[indexPath.row]
        
        if !_selectedItems.contains(seelctedArticle) {
            _selectedItems.append(seelctedArticle)
            selectedCell.accessoryType = .checkmark
            self.navigationItem.rightBarButtonItem?.isEnabled = _selectedItems.count > 0
            return
        }
        
        guard let selectedRowIndex = _selectedItems.index(of: seelctedArticle) else {
            return
        }
        
        _selectedItems.remove(at: selectedRowIndex)
        selectedCell.accessoryType = .none
        
        self.navigationItem.rightBarButtonItem?.isEnabled = _selectedItems.count > 0
    }
    
    
    // MARK: Actions
    
    @IBAction func buy(_ sender: UIBarButtonItem) {
        if _selectedItems.count == 0 {
            sender.isEnabled = false
            return
        }
        
        let alertController  = UIAlertController(title: "Pay via", message: nil, preferredStyle: .actionSheet)
        
        let cardAction       = UIAlertAction(title: "Credit/Debit card", style: .default, handler: self.payViaCard)
        let storedCardAction = UIAlertAction(title: "Stored card",       style: .default, handler: self.payViaStoredCard)
        let cancelAction     = UIAlertAction(title: "Cancel",            style: .cancel,  handler: nil)
        
        alertController.addAction(cardAction)
        alertController.addAction(storedCardAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kCardsSegue {
            guard let cardsController = segue.destination as? ICCardsTableViewController else {
                return
            }
            
            cardsController.cartItems = _selectedItems
        }
    }
    
    
    // MARK: Payment Delegate
    
    override func paymentDidComplete(withReference transactionReference: String) {
        super.paymentDidComplete(withReference: transactionReference)
        
        let transaction = ICTransaction(orderId: self.orderId ?? "", reference: transactionReference)
        UserDefaults.addTransaction(transaction)
    }
    
    override func paymentDidFailWithError(_ error: MobilePaymentSDKError) {
        super.paymentDidFailWithError(error)
        
        guard let orderId = self.orderId else {
            return
        }
        
        UserDefaults.deleteOrder(orderId)
    }
    
    
    // MARK: Private Methods
    
    private func setArticles() {
        _cartItems = [
            CartItem(name: "Book",  price: 10.00, quantity: 1),
            CartItem(name: "Shirt", price: 24.00, quantity: 1),
            CartItem(name: "Pens",  price: 0.25,  quantity: 4),
            CartItem(name: "Shoes", price: 45.75, quantity: 1),
            CartItem(name: "Chair", price: 72.55, quantity: 1),
        ]
    }
    
    private var payViaCard: ((_ alertAction: UIAlertAction) -> Void)? {
        return { (_) in
            let orderId  = ICUtils.randomOrderId
            self.orderId = orderId
            
            UserDefaults.addOrder(orderId)
            
            let controller = PaymentViewController(cartItems: self._selectedItems, orderId: orderId, delegate: self)
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    private var payViaStoredCard: ((_ alertAction: UIAlertAction) -> Void)? {
        return { (_) in
            self.performSegue(withIdentifier: self.kCardsSegue, sender: self)
        }
    }
}
