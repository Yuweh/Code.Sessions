//
//  InAppPurchaseManager.swift
//

import Foundation
import StoreKit

enum InAppPurchaseAlertType{
    case disabled
    case restored
    case purchased
    
    func message() -> String{
        switch self {
        case .disabled: return "Purchases are disabled in your device!"
        case .restored: return "You've successfully restored your purchase!"
        case .purchased: return "You've successfully bought this purchase!"
        }
    }
}

public class InAppPurchaseManager: NSObject {
    
    static let sharedInstance = InAppPurchaseManager() // Singleton
    
    fileprivate var productID: String = ""
    fileprivate var productRequest = SKProductsRequest()
    fileprivate var inAppPurchaseProducts = [SKProduct]()
    
    var purchaseStatusBlock: ((InAppPurchaseAlertType) -> Void)?
    let NON_CONSUMABLE_PURCHASE_PRODUCT_ID = "test nonCosumable Purchase"
    
    let preferences = UserDefaults.standard
    
    private override init() {
        super.init()
        Globals.log("InAppPurchaseManager init()")

        SKPaymentQueue.default().add(self)
    }
    
    // MARK: - MAKE PURCHASE OF A PRODUCT
    func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
    
    func purchaseMyProduct(index: Int){
        if inAppPurchaseProducts.count == 0 { return }
        
        if self.canMakePurchases() {
            let product = inAppPurchaseProducts[index]
            let payment = SKPayment(product: product)
            
            //SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
            
            print("PRODUCT TO PURCHASE: \(product.productIdentifier)")
            productID = product.productIdentifier
        } else {
            purchaseStatusBlock?(.disabled)
        }
    }
    
    // MARK: - RESTORE PURCHASE
    func restorePurchase(){
        //SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    
    // MARK: - FETCH AVAILABLE IAP PRODUCTS
    func fetchAvailableProducts(){
        // Put here your IAP Products ID's
        
        //*to be replaced: should be fetched from Apple or what is set, not constant
        let productIdentifiers = NSSet(objects: NON_CONSUMABLE_PURCHASE_PRODUCT_ID)

        productRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
        productRequest.delegate = self
        productRequest.start()
    }
    
}


extension InAppPurchaseManager: SKProductsRequestDelegate {
    
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        Globals.log("InAppPurchaseManager didReceive reponse:\(response)")
        
        if (response.products.count > 0) {
            inAppPurchaseProducts = response.products
            
            for product in inAppPurchaseProducts {
                let numberFormatter = NumberFormatter()
                numberFormatter.formatterBehavior = .behavior10_4
                numberFormatter.numberStyle = .currency
                numberFormatter.locale = product.priceLocale
                let price1Str = numberFormatter.string(from: product.price)
                
                Globals.log(product.localizedDescription + "\nfor just \(price1Str!)")
            }
            
            let validProduct: SKProduct = response.products[0] as SKProduct
            if (validProduct.productIdentifier == self.productID) {
                Globals.log("InAppPurchaseManager didReceive validProduct.localizedTitle:\(validProduct.localizedTitle)")
                Globals.log("InAppPurchaseManager didReceive validProduct.localizedTitle:validProduct.localizedDescription)")
                Globals.log("InAppPurchaseManager didReceive validProduct.localizedTitle:validProduct.price)")
                //buyProduct(product: validProduct)
            }
        }
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        Globals.log("InAppPurchaseManager didFailWith error:\(error)")
    }
    
    public func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        Globals.log("InAppPurchaseManager payment queue restored:\(queue)")
        Globals.log("InAppPurchaseManager Product Already Purchased")
        
        purchaseStatusBlock?(.restored)
        
        // Handle the purchase
        self.preferences.set(true, forKey: TktConstants.InAppPurchase.THI)
    }
    
}


extension InAppPurchaseManager: SKPaymentTransactionObserver {
    
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        Globals.log("InAppPurchaseManager updated transactions:\(transactions)")
        
        for transaction:AnyObject in transactions {
            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction{
                switch trans.transactionState {
                case .purchased:
                    Globals.log("InAppPurchaseManager Product Purchased")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    
                    // Handle the purchase
                    self.preferences.set(true , forKey: TktConstants.InAppPurchase.THI)
                    purchaseStatusBlock?(.purchased)
                    //adView.hidden = true
                    break
                    
                case .failed:
                    Globals.log("InAppPurchaseManager Purchased Failed")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                    
                case .restored:
                    Globals.log("InAppPurchaseManager Product Already Purchased")
                    SKPaymentQueue.default().restoreCompletedTransactions()
                    
                    // Handle the purchase
                    self.preferences.set(true , forKey: TktConstants.InAppPurchase.THI)
                    //adView.hidden = true
                    break
                    
                default:
                    break
                }
            }
        }
        
    }
    
}
