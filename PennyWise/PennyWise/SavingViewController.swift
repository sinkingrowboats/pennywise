//
//  SavingViewController.swift
//  PennyWise
//
//  Created by Samantha Rey on 8/24/17.
//  Copyright © 2017 Samantha Rey. All rights reserved.
//

import UIKit

/// UITableViewController file for the Wishlist app view
class SavingViewController: UIViewController {
    
    ///
    /// MARK: - Stored Properties
    ///
    
    let defaults = UserDefaults.standard
    
    var totalSavings: Double = 0.0
    
    var items: [WishListItem] = []
    
    
    ///
    /// MARK: - Layout Properties
    ///
    
    var yOffset: CGFloat = 50
    var cellHeight: CGFloat = 65
    var tabBarHeight: CGFloat = 0
    
    @IBOutlet weak var savingsView: UIView!
    @IBOutlet weak var wishlistView: UIView!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var wishlistTitle: UILabel!
    @IBOutlet weak var savingsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    
    @IBOutlet weak var wishlistViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Make instruction view invisible
        infoView.alpha = 0
        backButton.isUserInteractionEnabled = false
        
        //Fetch stored properties for display
        items = getWishlist()
        totalSavings = getTotalSavings()
        
        savingsLabel.text = "$" + String(format: "%.2f", totalSavings)

        let horizontalSizeClass = self.view.traitCollection.horizontalSizeClass
        let verticalSizeClass = self.view.traitCollection.verticalSizeClass
        
        if(horizontalSizeClass == .compact && verticalSizeClass == .compact) {
            yOffset = 20
            cellHeight = 55
        }
        else if (horizontalSizeClass == .compact && verticalSizeClass == .regular) {
            yOffset = 25
            cellHeight = 55
        }
        else if (horizontalSizeClass == .regular && verticalSizeClass == .compact) {
            yOffset = 30
            cellHeight = 55
        }
 
        tableView.reloadData()
        
        let stockTabBar = UITabBarController()
        tabBarHeight = stockTabBar.tabBar.frame.size.height
        
        /// MARK: Adding Button Actions
        
        backButton.addTarget(self, action: #selector(backTapped(sender:)), for: .touchUpInside)
        infoButton.addTarget(self, action: #selector(infoTapped(sender:)), for: .touchUpInside)
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWishButton(_:)))
        let editButton = editButtonItem
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil);
        toolbar.items = [editButton, flexibleSpace, addButton]
        
        ///
        /// MARK: Notification Center
        ///
        
        NotificationCenter.default.addObserver(self, selector: #selector(SavingViewController.adjustContent), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SavingViewController.resigningActive), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SavingViewController.terminating), name: NSNotification.Name.UIApplicationWillTerminate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SavingViewController.returningToActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
 
        adjustContent()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        adjustContent()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    ///
    /// MARK: - Layout Methods
    ///
    
    /**
     Adjust the Height of the Wishlist tableview to fit it's contents
     
     - Returns: Void
     */
    func adjustTableViewHeight() {
        let toolbarHeight = toolbar.bounds.height
        let totalCellHeight = CGFloat(items.count) * cellHeight
        tableViewHeight.constant = totalCellHeight + toolbarHeight
    }
    
    /**
     Adjust the Height of the Wishlist superview to fit it's contents
     
     - Returns: Void
     */
    func adjustWishlistViewHeight() {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        var titleMaxHeight: CGFloat = 0
        
        if(width > height) {
            titleMaxHeight = width * 0.1
        }
        else {
            titleMaxHeight = height * 0.1
        }
 
        wishlistViewHeight.constant = tableViewHeight.constant + 5 +  titleMaxHeight + 1
    }
    
    /**
     Adjust the Height of the Scrollview content to fit it's subviews contents
     
     - Returns: Void
     */
    func adjustContentViewHeight() {
        
        let contentHeight = (yOffset * 3) + tabBarHeight + savingsView.bounds.height + wishlistViewHeight.constant
        scroll.contentSize = CGSize(width: 0, height: contentHeight)
    }
 
    /**
     Function to adjust all adjustable content heights
     
     - Returns: Void
     */
    func adjustContent() {
        adjustTableViewHeight()
        adjustWishlistViewHeight()
        adjustContentViewHeight()
        self.view.layoutIfNeeded()
    }
    
    
    ///
    /// MARK: - Button Actions
    ///
    
    /**
     Display Instructions view when info button is pressed
     
     - Parameter sender: info button
     
     - Returns: Void
     */
    func infoTapped(sender: UIButton!) {
        self.view.addSubview(infoView)
        backButton.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.4, animations: {
            self.infoView.alpha = 1
        }, completion: nil)
    }
    
    /**
     Hide instructions view when back button is pressed
     
     - Parameter sender: back button
     
     - Returns: Void
     */
    func backTapped(sender: UIButton!) {
        UIView.animate(withDuration: 0.4, animations: {
            self.infoView.alpha = 0
        }, completion: nil)
    }
 
    
    ///
    /// MARK: - Wishlist Methods
    ///
    
    /**
     Add a new Wish to the Wishlist
     
     - Returns: Void
     */
    func addWish() {
        print("INFO: Displaying alerts to add new wish to wishlist")
        print("TRACE: Displaying alerts with textfield to add name of wishlist item")
        
        var name = ""
        let alert = UIAlertController(title: "Add Item to Wishlist",
                                      message: "Enter the Name of your Item",
                                      preferredStyle: .alert)
        
        let next = UIAlertAction(title: "Next", style: .default) { (action) in

            if let textField = alert.textFields?.first {
                if let nameToSave = textField.text {
                    if(nameToSave.isEmpty) {
                        print("INFO: user left textfield empty, will not create a new wishlist item with an empty string for a name")
                        let badAlert = UIAlertController(title: "Bad Entry", message: "Please Enter a Name for Your Item (Must be at least 1 character long)", preferredStyle: .alert)
                        let noEntry = UIAlertAction(title: "Try Again", style: .default) { (action) in
                            self.addWish()
                        }
                        
                        badAlert.addAction(noEntry)
                        self.present(badAlert, animated: true, completion: nil)
                    }
                    else {
                        print("TRACE: Displaying alert with textfield to add price of wishlist item")
                        name = nameToSave
                        
                        let alert2 = UIAlertController(title: "Add Item to Wishlist", message: "Enter the Price of your Item", preferredStyle: .alert)
                        
                        let saveAction = UIAlertAction(title: "Save Item", style: .default) { (action) in
                            if let textField2 = alert2.textFields?.first {
                                if let priceToSave = textField2.text {
                                    if let priceDouble = Double(priceToSave) {
                                        print("INFO: Information entered in textfields is valid, creating new wishlist item from those properties")
                                        let newItem = WishListItem(name: name, price: priceDouble)
                                        self.addItemToWishlist(item: newItem)
                                        self.tableView.reloadData()
                                        self.adjustContent()
                                    }
                                    else {
                                        print("INFO: text entered was not a valid number, will not create a wishlist item without a valid cost")
                                        let badAlert2 = UIAlertController(title: "Bad Entry", message: "Please Enter a Valid Price for your Item (Must be a valid number)", preferredStyle: .alert)
                                        let noEntry2 = UIAlertAction(title: "Try Again", style: .default) { (action) in
                                            self.addWish()
                                        }
                                        
                                        badAlert2.addAction(noEntry2)
                                        self.present(badAlert2, animated: true, completion: nil)
                                    }
                                }
                            }
                            else {
                                return
                            }
                        }
                        
                        let cancel2 = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                        
                        alert2.addTextField()
                        
                        alert2.addAction(saveAction)
                        alert2.addAction(cancel2)
                        self.present(alert2, animated: true, completion: nil)
                    }
                }
            }
            else {
                return
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alert.addTextField()
        
        alert.addAction(next)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
 
    /**
     Button action item to addWish. Unlike addWish(), addWishButton specifies a UIBarButtonItem sender
     
     - Parameter sender: the "+" UIBarButtonItem
     
     - Returns: Void
     */
    func addWishButton(_ sender: UIBarButtonItem){
        addWish()
    }
    
    /**
     function that appends a wishlist item to wishlist. NOTE: This function will be expanded in the future, that's the only reason it exists
     
     - Parameter item: WishlistItem to add
     
     - Returns: Void
     */
    func addItemToWishlist(item: WishListItem) {
        items.append(item)
    }
    
    /**
     Retrieve Wishlist from memory
     
     - Returns: Wishlist stored in NSUserDefaults
     */
    func getWishlist() -> [WishListItem] {
        if let data = defaults.object(forKey: "wishlist"){
            let object = NSKeyedUnarchiver.unarchiveObject(with: (data as! NSData) as Data)
            if let purchaseArr = object as? [WishListItem] {
                return purchaseArr
            }
            else {
                return []
            }
        }
        else {
            return []
        }
    }
    
    /**
     Retrieve Total Savings from memory
     
     - Returns: The Double Value of the total savings
     */
    func getTotalSavings() -> Double {
        let savedSavings = defaults.double(forKey: "savedSavings")
        return savedSavings
    }
    
    /**
     Save Wishlist to memory before resigned from active and potentially terminated
     
     - Parameter notificaion: ApplicationWillResignActive notification
     
     - Returns: Void
     */
    func resigningActive(notification: NSNotification) {
        if(items.isEmpty) {
            defaults.set(nil, forKey: "wishlist")
        }
            
        else {
            let archiver = NSKeyedArchiver.archivedData(withRootObject: self.items)
            defaults.set(archiver, forKey: "wishlist")
        }
        defaults.synchronize()
    }
    
    /**
     Remove observers before app resigns
     
     - Parameter notificaion: ApplicationWillTerminate notification
     
     - Returns: Void
     */
    func terminating(notification: NSNotification) {
        NotificationCenter.default.removeObserver(self)
    }
    
    /**
     Reconfigure views after app returns from backgroiund
     
     - Parameter notificaion: ApplicationDidBecomeActive notification
     
     - Returns: Void
     */
    func returningToActive(notification: NSNotification) {
        adjustContent()
    }

}

///
/// MARK: - UITableView Delegate Functions
///
extension SavingViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "WishlistTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? WishlistTableViewCell else {
            fatalError("The dequeued cell is not an instance of WishlistTableViewCell.")
        }
        
        cell.selectionStyle = .none
        
        
        let name = items[indexPath.row].name
        let price = items[indexPath.row].price
        
        cell.nameLabel.text = name
        cell.priceLabel.text = "$" + String(format: "%.0f", price)
        
        var multiplier: CGFloat = 0
        if(price == 0) {
            multiplier = 1
        }
        else {
            multiplier = CGFloat(totalSavings/price)
            if (multiplier >= 1) {
                multiplier = 1
            }
        }

        cell.priceGuageConstraint = cell.priceGuageConstraint.setMultiplier(multiplier: multiplier)
        
        cell.layoutIfNeeded()
        
        return cell
    }
 
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if(self.view.traitCollection.horizontalSizeClass == .compact ||
            self.view.traitCollection.verticalSizeClass == .compact) {
            cellHeight = 55
            return 55
        }
        else{
            return 65
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.adjustContent()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
}


extension NSLayoutConstraint {
    
    /**
     resetMultiplier on NSLayoutConstraint
     
     - Parameter multiplier: new multiplier for the constraint
     
     - Returns: Void
     */
    func setMultiplier(multiplier:CGFloat) -> NSLayoutConstraint {
        // Attribution: https://stackoverflow.com/questions/37294522/ios-change-the-multiplier-of-constraint-by-swift change the multiplier constant of a layout constraint since the property is a "get only"
        
        NSLayoutConstraint.deactivate([self])
        
        let newConstraint = NSLayoutConstraint(
            item: firstItem,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier
        
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
}
