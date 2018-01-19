
import Foundation
import UIKit

struct CustomerConcern {
    private(set) public var titleConcern: String
    private(set) public var type: String
    
    init(titleConcern: String, type: String) {
        self.titleConcern = titleConcern
        self.type = type
    }
    
}

struct Data {
    
    static var customerConcerns = [
        CustomerConcern(titleConcern: "Cannot Access Account", type: "1"),
        CustomerConcern(titleConcern: "Cannot Reload", type: "2"),
        CustomerConcern(titleConcern: "Cannot Transfer Funds", type: "3")
    ]
    
    //static var customerConerns: String = ["Cannot Access Account", "Cannot Reload", "Cannot Transfer Funds"]()
    static var type: String = ["1", "2", "3"]
}

class CustomerQueries {
    
    static let instance = CustomerQueries()
    
    let customerConcerns = [
        CustomerConcern(titleConcern: "Cannot Access Account", type: "1"),
        CustomerConcern(titleConcern: "Cannot Reload", type: "2"),
        CustomerConcern(titleConcern: "Cannot Transfer Funds", type: "3")
    ]
    
    func getCustomerConcerns() -> [CustomerConcern] {
        return customerConcerns
    }
}
