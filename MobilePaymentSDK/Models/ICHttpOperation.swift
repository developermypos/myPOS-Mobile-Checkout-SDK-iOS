//
//  ICHttpOperation.swift
//  MobilePaymentSDK
//
//  Created by Valio Cholakov on 1/13/17.
//  Copyright © 2017 Intercard Finance AD. All rights reserved.
//

import Foundation

class ICHttpOperation: Operation, NSURLConnectionDataDelegate {
    
    typealias success = (_ response: NSDictionary) -> Void
    typealias error = (_ error: MobilePaymentSDKError) -> Void
    
    // MARK: Properties
    
    private var _finished  = false
    private var _executing = false
    
    private(set) var success: success?
    private(set) var error: error?
    
    private var _response: Any?
    private var _request: URLRequest!
    
    private var _responseData: Data = Data()
    private var _urlConnection: NSURLConnection?
    
    private let _operationQueue = DispatchQueue(label: "com.ipay.mobilePaymentSDK-operation", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
    
    
    // MARK: (De)Initializers
    
    init(request: ICURLRequest, onSuccess: success?, onError: error?) {
        _request     = request.urlRequest
        self.error   = onError
        self.success = onSuccess
    }
    
    
    deinit {
        _request      = nil
        _response     = nil
        self.error    = nil
        self.success  = nil
        
        guard let urlConnection = _urlConnection else {
            return
        }
        
        urlConnection.cancel()
        self.completeOperation()
    }
    
    
    // MARK: Operation Methods
    
    override func main() {
        _urlConnection = NSURLConnection(request: _request, delegate: self)
        
        while !_finished && !self.isCancelled {
            RunLoop.current.run(mode: .defaultRunLoopMode, before: NSDate.distantFuture)
        }
    }
    
    override func start() {
        _operationQueue.async {
            self.main()
        }
        
        if self.isCancelled {
            self.willChangeValue(forKey: String(describing: self.isFinished))
            _finished = true
            self.didChangeValue(forKey: String(describing: self.isFinished))
            return
        }
        
        _executing = true
    }
    
    override func cancel() {
        if let urlConnection = _urlConnection {
            urlConnection.cancel()
            _urlConnection = nil
        }
        
        self.completeOperation()
    }
    
    
    // MARK: NSURLConnection Delegate
    
    func connection(_ connection: NSURLConnection, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.operationEncounteredAnError(error)
            self.completeOperation()
        }
    }
    
    func connection(_ connection: NSURLConnection, didReceive data: Data) {
        _responseData.append(data)
    }
    
    func connectionDidFinishLoading(_ connection: NSURLConnection) {
        DispatchQueue.main.async {
            self.readResponse()
            self.completeOperation()
        }
    }
    
    override var isFinished: Bool {
        return _finished
    }
    
    override var isExecuting: Bool {
        return _executing
    }
    
    override var isConcurrent: Bool {
        return true
    }
    
    
    // MARK: Private Methods
    
    private func completeOperation() {
        _urlConnection = nil
        _finished      = true
        _executing     = false
        
        _responseData.removeAll()
    }
    
    private func readResponse() {
        if _responseData.count == 0 {
            return
        }
        
        guard let rawResponse = String(data: _responseData, encoding: .utf8) else {
            ICLogger.logDebug("Empty response")
            self.communicationError()
            return
        }
        
        var rawResponseData = rawResponse.components(separatedBy: ",")
        
        var json: Any?
        
        do {
            json = try JSONSerialization.jsonObject(with: _responseData, options: .mutableContainers)
        } catch {
            ICLogger.logDebug("Cannot parse response to JSON")
            self.communicationError()
            return
        }
        
        guard let response = json as? NSDictionary else {
            self.communicationError()
            return
        }
        
        ICLogger.logDebug("Response: \(response)")
        
        guard let signature = response[ICParameters.signature]     as? String,
              let status    = response[ICParameters.status]        as? Int,
              let statusMsg = response[ICParameters.statusMessage] as? String
            else {
                ICLogger.logDebug("Missing data in response")
                self.communicationError()
                return
        }
        
        ICLogger.log("Status: \(status) - \(statusMsg)")
        ICLogger.log("Validating response...")
        
        var dataToValidate: String = ""
        
        rawResponseData.removeLast() // Remove signature
        
        for rawData in rawResponseData {
            guard let value = rawData.components(separatedBy: ":").last else {
                continue
            }
            
            dataToValidate = dataToValidate + "-" + value
        }
        
        dataToValidate = dataToValidate.substring(from: 1).replacingOccurrences(of: "\"", with: "")
        
        ICLogger.logDebug("Signature must match \(dataToValidate)")
        let signatureIsValid = signature.isValidSignature(of: dataToValidate.base64Encoded())
        ICLogger.log("Response is \(signatureIsValid ? "" : "in")valid")
        
        if !signatureIsValid {
            self.signatureError()
            return
        }
        
        if status != ICResponseStatus.ok {
            self.communicationError()
            return
        }
        
        self.success?(response)
        self.completeOperation()
    }
    
    private func communicationError() {
        self.completeWithStatus(.communicationError)
    }
    
    private func signatureError() {
        self.completeWithStatus(.signatureValidationError)
    }
    
    private func completeWithStatus(_ status: MobilePaymentSDKError.status) {
        self.error?(self.errorWithStatus(status))
        self.completeOperation()
    }
    
    private func operationEncounteredAnError(_ error: Error?) {
        guard let error = error else {
            return
        }
        
        self.error?(error as! MobilePaymentSDKError)
        self.completeOperation()
    }
    
    private func errorWithStatus(_ status: MobilePaymentSDKError.status) -> MobilePaymentSDKError {
        return MobilePaymentSDKError(status: status)
    }
}
