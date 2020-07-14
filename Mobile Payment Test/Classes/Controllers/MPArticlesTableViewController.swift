//
//  MPArticlesTableViewController.swift
//  Mobile Payment Test
//
//  Created by Valio Cholakov on 1/16/17.
//  Copyright © 2020 myPOS AD. All rights reserved.
//

import UIKit

class MPArticlesTableViewController: MPBaseTableViewController {
    
    // MARK: Constants
    
    private let kCardsSegue     = "cards"
    private let kCellIdentifier = "article"
    
    
    // MARK: Variables
    
    private var orderId: String?
    private var _cartItems: [MPCartItem] = []
    private var _selectedItems: [MPCartItem] = []
    

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
        
        if let articleCell = cell as? MPArticleTableViewCell {
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
        let preAuthorization = UIAlertAction(title: "Pre-authorization", style: .default, handler: self.payViaPreAuthorization)
        let authorization    = UIAlertAction(title: "Authorization",     style: .default, handler: self.payViaAuthorization)
        let cancelAction     = UIAlertAction(title: "Cancel",            style: .cancel,  handler: nil)
        
        alertController.addAction(cardAction)
        alertController.addAction(storedCardAction)
        alertController.addAction(preAuthorization)
        alertController.addAction(authorization)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kCardsSegue {
            guard let cardsController = segue.destination as? MPCardsTableViewController else {
                return
            }
            
            cardsController.cartItems = _selectedItems
        }
    }
    
    
    // MARK: Payment Delegate
    
    override func paymentDidComplete(withReference transactionReference: String) {
        super.paymentDidComplete(withReference: transactionReference)
        
        let transaction = MPTransaction(orderId: self.orderId ?? "", reference: transactionReference)
        UserDefaults.addTransaction(transaction)
    }
    
    override func paymentDidFailWithError(_ error: MPCheckoutError) {
        super.paymentDidFailWithError(error)
        
        guard let orderId = self.orderId else {
            return
        }
        
        UserDefaults.deleteOrder(orderId)
    }
    
    
    // MARK: Private Methods
    
    private func setArticles() {
        _cartItems = [
            MPCartItem(name: "Test",  price: 0.01,  quantity: 1),
            MPCartItem(name: "Book",  price: 10.00, quantity: 1),
            MPCartItem(name: "Shirt", price: 24.00, quantity: 1),
            MPCartItem(name: "Pens",  price: 0.25,  quantity: 4),
            MPCartItem(name: "Shoes", price: 45.75, quantity: 1),
            MPCartItem(name: "Chair", price: 72.55, quantity: 1),
        ]
    }
    
    private var payViaCard: ((_ alertAction: UIAlertAction) -> Void)? {
        return { (_) in
            let orderId  = MPUtils.randomOrderId
            self.orderId = orderId
            
            UserDefaults.addOrder(orderId)
            
            let controller = MPPaymentViewController(cartItems: self._selectedItems, orderId: orderId, delegate: self)
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    private var payViaStoredCard: ((_ alertAction: UIAlertAction) -> Void)? {
        return { (_) in
            self.performSegue(withIdentifier: self.kCardsSegue, sender: self)
        }
    }
    
    private var payViaPreAuthorization: ((_ alertAction: UIAlertAction) -> Void)? {
        return { (_) in
            let orderId  = MPUtils.randomOrderId
            self.orderId = orderId
            
            var items = ""
            var amount: CGFloat = 0.0
            
            for item in self._selectedItems {
                items += "\(item.name ?? ""), "
                amount += item.price
            }
            
            let index = items.index(items.startIndex, offsetBy: items.count - 2)
            
            let controller = MPPreAuthorizationViewController(itemName: String(items[..<index]),
                                                              amount: amount,
                                                              orderId: orderId,
                                                              delegate: self)
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    private var payViaAuthorization: ((_ alertAction: UIAlertAction) -> Void)? {
        return { (_) in
            let cards: [MPCard] = MPUtils.cards
            let chooseCardController = UIAlertController(title: "Select card", message: nil, preferredStyle: .actionSheet)
            
            chooseCardController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            for card in cards {
                chooseCardController.addAction(UIAlertAction(title: card.name, style: .default, handler: { (_) in
                    let orderId  = MPUtils.randomOrderId
                    self.orderId = orderId
                    
                    var items = ""
                    var amount: CGFloat = 0.0
                    
                    for item in self._selectedItems {
                        items += "\(item.name ?? ""), "
                        amount += item.price
                    }
                    
                    let index = items.index(items.startIndex, offsetBy: items.count - 2)
                    
                    self.showLoadingHUD()
                    MPCheckout.makeAuthorization(forItem: String(items[..<index]),
                                                 withAmount: amount,
                                                 orderId: orderId,
                                                 cardToken: card.token,
                                                 completion: { (trnRef) in
                                                    self.hideLoadingHUD()
                                                    let alert = UIAlertController(title: "myPOS", message: "Operation completed successfully", preferredStyle: .alert)
                                                    alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: { [weak self] (_) in
                                                        self?.navigationController?.popViewController(animated: true)
                                                    }))
                                                    self.present(alert, animated: true, completion: nil)
                    }) { (error) in
                        print(error.localizedDescription)
                        self.hideLoadingHUD()
                    }
                }))
            }
            
            self.present(chooseCardController, animated: true, completion: nil)
        }
    }
}
