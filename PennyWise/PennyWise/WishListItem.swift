//
//  WishListItem.swift
//  PennyWise
//
//  Created by Samantha Rey on 8/25/17.
//  Copyright © 2017 Samantha Rey. All rights reserved.
//

import UIKit

/**
 WishListItem Class, class that stores all information for an item in the user's wishlist
 */
class WishListItem: NSObject, NSCoding {
    /// name of wishlist item
    var name: String
    /// price of wishlist item
    var price: Double
    
    init(name: String, price: Double) {
        self.name = name
        self.price = price
    }
    
    
    ///
    /// MARK: - NSCoding protocol methods
    ///
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.price = aDecoder.decodeDouble(forKey: "price")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(price, forKey: "price")
    }
}
