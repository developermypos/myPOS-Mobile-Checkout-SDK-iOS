//
//  IC3DSecureWebViewController.swift
//  LeuPay
//
//  Created by Valio Cholakov on 1/9/17.
//  Copyright © 2016 Intercard Finance AD. All rights reserved.
//

import UIKit

class IC3DSecureWebViewController: ICBaseViewController, UIWebViewDelegate {

    // MARK: Outlets
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    
    // MARK: Variables
    
    var urlRequest: URLRequest?
    open weak var delegate: IC3DSecureDelegate?
    
    
    // MARK: Controller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.customInit()
        self.applyTheme()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let urlRequest = self.urlRequest else {
            return
        }
        
        self.webView.loadRequest(urlRequest)
    }
    
    deinit {
        self.delegate   = nil
        self.urlRequest = nil
    }
    
    
    // MARK: Localization
    
    override func localize() {
        self.navigationItem.title = ICLocalization.localized("3D Secure")
        self.cancelButton.title   = ICLocalization.localized("Cancel")
        
        super.localize()
    }
    
    
    // MARK: Actions
    
    @IBAction func cancel(_ sender: AnyObject) {
        self.delegate?.didCancel3DS?()
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: Web View Delegate
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if let url = webView.request!.url?.absoluteString {
            if !url.contains("icard")   &&
               !url.contains("leupay")  &&
               !url.contains("leupost") &&
               !url.contains("gateway") {
                self.hideLoadingHUD()
            }
        }
        
        ICLogger.logDebug(webView.request?.url?.absoluteString)
        
        self.readResponse()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        if (error as NSError).code == -1005 {
            self.webView.loadRequest(self.urlRequest!)
            return
        }
        
        ICLogger.logDebug("Web view error: \(error)")
        self.hideLoadingHUD()
    }
    
    
    // MARK: Private Methods
    
    fileprivate func customInit() {
        self.webView.delegate = self
        
        if self.urlRequest != nil {
            self.showLoadingHUD()
        }
    }
    
    override func applyTheme() {
        self.webView.isOpaque          = false
        self.webView.backgroundColor = UIColor.white
    }
    
    fileprivate func readResponse() {
        let body: NSString = self.webView.stringByEvaluatingJavaScript(from: "document.body.innerHTML")! as NSString
        let range = body.range(of: "\\{.+\\}", options: .regularExpression)
        
        if range.location != NSNotFound {
            let response = body.substring(with: range)
            
            do {
                let json = try JSONSerialization.jsonObject(with: response.data(using: String.Encoding.utf8)!, options: .allowFragments)
                
                self.delegate?.didReceive3DSecureResponse?(json as! NSDictionary)
                self.navigationController?.dismiss(animated: true, completion: nil)
            } catch {
                ICLogger.logDebug("Could not format response '\(response)' to json")
            }
        }
    }
}

@objc protocol IC3DSecureDelegate {
    @objc optional func didReceive3DSecureResponse(_ response: NSDictionary)
    @objc optional func didCancel3DS()
}
