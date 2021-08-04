//
//  dummyPurchaseData.swift
//  PennyWise
//
//  Created by Samantha Rey on 8/23/17.
//  Copyright © 2017 Samantha Rey. All rights reserved.
//

import UIKit

/**
DummyPurchase Class, class of all static methods that provide static data for the app to function presently
 */
class DummyPurchaseData: NSObject {
    static func returnDummyPurchaseArray() -> [Purchase] {
        let date = Date()
        
        let purchase1 = Purchase(title: "Venmo AHC Transaction", price: 15.00, date: date, pending: false)
        let purchase2 = Purchase(title: "Starbucks Coffee", price: 4.50, date: date, pending: false)
        let purchase3 = Purchase(title: "Target Marketplace", price: 35.00, date: date, pending: false)
        let purchase4 = Purchase(title: "Chipotle Mexican Grill", price: 8.00, date: date, pending: true)
        
        return [purchase1, purchase2, purchase3, purchase4]
    }
    
    static func returnDummyItemsArray() -> [WishListItem] {
        let item1 = WishListItem(name: "Gelato Maker", price: 255)
        let item2 = WishListItem(name: "Concert Tickets", price: 75.50)
        let item3 = WishListItem(name: "Phone Case", price: 12.50)
        let item4 = WishListItem(name: "Gum", price: 2.50)
        
        return [item1, item2, item3, item4]
    }
}
