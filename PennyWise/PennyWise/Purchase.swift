//
//  Purchase.swift
//  PennyWise
//
//  Created by Samantha Rey on 8/23/17.
//  Copyright © 2017 Samantha Rey. All rights reserved.
//

import UIKit

/**
 Purcase Class, class that stores all information for a purchase made by the user
 */
class Purchase: NSObject, NSCoding {
    /// title of purchase
    var title: String
    /// price of purchase
    var price: Double
    /// date purchase was made
    var date: Date
    /// whether or not purchase is pending or not (like if you paid with a credit card at a restaurant before the tip is established)
    var pending: Bool
    /// category indicating the type of purchase (ex Food, Gas, etc)
    var category: String = ""
    /// amount saved on the purchase as determined by what the user indicated they wanted to spend on it
    var saved: Double = 0
    
    /**
     Initialize a purchase object will all information that is absolutely necessary
     
     - Returns: Void
     */
    init(title: String, price: Double, date: Date, pending: Bool) {
        self.title = title
        self.price = price
        self.date = date
        self.pending = pending
    }
    
    /**
     Initialize a purchase object with all information
     
     - Returns: Void
     */
    init(title: String, price: Double, date: Date, pending: Bool, category: String, saved: Double) {
        self.title = title
        self.price = price
        self.date = date
        self.pending = pending
        self.category = category
        self.saved = saved
    }
    
    /**
     Initialize a purchase object will all information that is absolutely necessary
     
     - Returns: Void
     */
    required init?(coder aDecoder: NSCoder) {
        self.title = aDecoder.decodeObject(forKey: "title") as! String
        self.price = aDecoder.decodeDouble(forKey: "price")
        self.date = aDecoder.decodeObject(forKey: "date") as! Date
        self.pending = aDecoder.decodeBool(forKey: "pending")
        self.category = aDecoder.decodeObject(forKey: "category") as! String
        self.saved = aDecoder.decodeDouble(forKey: "saved")
    }
    
    
    ///
    /// MARK: - NSCoding protocol methods
    ///
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(price, forKey: "price")
        aCoder.encode(date, forKey: "date")
        aCoder.encode(pending, forKey: "pending")
        aCoder.encode(category, forKey: "category")
        aCoder.encode(saved, forKey: "saved")
    }
    
    
}
