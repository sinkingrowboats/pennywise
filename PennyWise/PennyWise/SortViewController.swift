//
//  SortViewController.swift
//  PennyWise
//
//  Created by Samantha Rey on 8/20/17.
//  Copyright © 2017 Samantha Rey. All rights reserved.
//

import UIKit

/// UITableViewController file for the sorting game views
class SortViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    ///
    /// MARK: - Miscellaneous Properties
    ///
    
    /// MARK: - User Defaults
    let defaults = UserDefaults.standard
    
    /// MARK: Transition Properties
    let circleTransition = CircularTransition()
    
    ///
    /// MARK: - Purchase Properties
    ///
    
    var index: Int = 0
    var purchaseArray: [Purchase] = []
    var purchase: Purchase? = nil
    var purchaseDate: String {
        if let uPurchase = purchase {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            return dateFormatter.string(from: uPurchase.date)
        }
        else {
            return ""
        }
    }
    var pending: Bool {
        if let uPurchase = purchase {
            return uPurchase.pending
        }
        else {
            return false
        }
    }
    var purchasePrice: Double {
        if let uPurchase = purchase {
            return uPurchase.price
        }
        else {
            return 0
        }
    }
    var purchaseTitle: String {
        if let uPurchase = purchase {
            return uPurchase.title
        }
        else {
            return ""
        }
    }
    
    
    ///
    /// MARK: - Layout Properties
    ///
    
    var screenWidth: CGFloat = 0
    var screenHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    var viewHeight: CGFloat = 0
    var horizontalCenter: CGFloat {
        return screenWidth/2.0
    }
    var verticalCenter: CGFloat {
        return screenHeight/2.0
    }
    var horizontalSizeClass = UIUserInterfaceSizeClass.compact
    var verticalSizeClass = UIUserInterfaceSizeClass.compact
    var yOffset: CGFloat {
        return screenHeight * 0.05
    }
    
    let prompt: String = "How much would you like to spend? Don't forget to add the cents!"
    var actualString: String = "Actual Price"
    var lastLength = 0
    
    /// MARK: Shortcut for App Palette Colors
    let salmon = UIColor(colorLiteralRed: 255.0/255.0, green: 116.0/255.0, blue: 109.0/255.0, alpha: 1.0)
    let white = UIColor.white
    let yellow = UIColor(colorLiteralRed: 255.0/255.0, green: 244.0/255.0, blue: 166.0/255.0, alpha: 1.0)
    let green = UIColor(colorLiteralRed: 64.0/255.0, green: 152.0/255.0, blue: 78.0/255.0, alpha: 1.0)
    let red = UIColor(colorLiteralRed: 177.0/255.0, green: 32.0/255.0, blue: 54.0/255.0, alpha: 1.0)
    
    /// MARK: Multipliers for Determining Height and Width of certain views
    var titleWidthMultiplier: CGFloat = 0.77
    var titleHeightMultiplier: CGFloat = 0.175
    var titleFontSize: CGFloat = 30
    var dateWidthMultiplier: CGFloat = 0.5
    var dateHeightMultiplier: CGFloat = 0.09
    var dateFontSize: CGFloat = 20
    var promptHeightMultiplier: CGFloat = 0.12
    var promptFontSize: CGFloat = 14
    var priceViewHeightMultiplier: CGFloat = 0.15
    var priceFontSize: CGFloat = 65
    var actualLabelWidthMultiplier: CGFloat = 0.7
    var actualLabelHeightMultiplier: CGFloat = 0.1
    var actualLabelFontSize: CGFloat = 18
    var labelOpacities: CGFloat = 1
    var skipButtonFontSize: CGFloat = 15
    var skipButtonHeightOffsetMultiplier: CGFloat = 0.12
    var skipButtonWidthOffset: CGFloat = 10
    
    /// MARK: - Layout elements
    let purchaseTitleLabel = UILabel()
    let purchaseDateLabel = UILabel()
    let promptLabel = UILabel()
    let enterPriceView = UIView()
    let priceDollar = UILabel()
    let priceField = UITextField()
    let actualPriceLabel = UILabel()
    let actualPriceField = UITextField()
    let actualPriceView = UIView()
    let actualDollar = UILabel()
    let savingsPlus = UILabel()
    let skipButton = UIButton()
    let infoButton = UIButton(type: .infoLight)

    ///
    /// MARK: - Existing Methods
    ///
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// MARK: Adding target functions
        skipButton.addTarget(self, action: #selector(skipTapped(sender:)), for: .touchUpInside)
        infoButton.addTarget(self, action: #selector(infoTapped(sender:)), for: .touchUpInside)
        priceField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        
        /// MARK: Notification center
        NotificationCenter.default.addObserver(self, selector: #selector(SortViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SortViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SortViewController.resigningActive), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SortViewController.terminating), name: NSNotification.Name.UIApplicationWillTerminate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SortViewController.returningToActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        /// MARK: configure the layout of the view
        loadLayout()
        
        self.view.backgroundColor = salmon
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // To prevent users from rotating the screen during sorting
    override var shouldAutorotate: Bool {
        return false
    }
    
    /// MARK: UIViewControllerTransitioningDelegate Methods
    func animationController(forPresented presented: UIViewController, presenting:
        UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        circleTransition.transitionMode = .present
        circleTransition.startingpoint = self.view.center
        circleTransition.circleColor = UIColor(colorLiteralRed: 255.0/255.0, green: 116.0/255.0, blue: 109.0/255.0, alpha: 1.0)
        
        return circleTransition
    }
    
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        circleTransition.transitionMode = .dismiss
        circleTransition.startingpoint = self.view.center
        circleTransition.circleColor = UIColor.red
        
        return circleTransition
    }
    
    
    ///
    /// MARK: - Custom Methods
    ///
    
    ///MARK: - Layout Configuration Methods
    
    /**
     Configure layout for the SorViewController
     
     - Returns: Void
     */
    func loadLayout() {
        skipButton.isUserInteractionEnabled = true
        priceField.isUserInteractionEnabled = true
        priceField.text = ""
        
        purchase = purchaseArray[index]
        
        viewWidth = self.view.frame.width
        viewHeight = self.view.frame.height
        screenWidth = UIScreen.main.bounds.width
        screenHeight = UIScreen.main.bounds.height
        
        horizontalSizeClass = self.view.traitCollection.horizontalSizeClass
        verticalSizeClass = self.view.traitCollection.verticalSizeClass
        
        configureSortLayout()
        
        let dispatchTime = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            self.priceField.becomeFirstResponder()
        }
    }
    
    /**
     Layout configuration helper function, changes some font sizes based on the size class of the device
     
     - Returns: Void
     */
    func configureSortLayout() {
        if(horizontalSizeClass == .regular && verticalSizeClass == .regular) {
            titleFontSize = 65
            dateFontSize = 50
            promptFontSize = 35
            priceFontSize = 95
            actualLabelFontSize = 40
            skipButtonWidthOffset = 17
        }
        else if((horizontalSizeClass == .regular && verticalSizeClass == .compact) || screenHeight > 700) {
            titleFontSize = 40
            dateFontSize = 30
            promptFontSize = 20
            priceFontSize = 65
            actualLabelFontSize = 24

        }
        
        configureSortLayoutDetail()
    }
    
    /**
     Layout configuration helper function. Creates frame for all elements in the SortViewController, assigns all of their properties, and places them in the correct place in the view. Very long function because it configures the properties of all views that are in ViewController at load
     
     - Returns: Void
     */
    func configureSortLayoutDetail() {
        if(pending) {
            actualString = "Pending"
            labelOpacities = 0.7
        }
        
        let purchaseLabelWidth: CGFloat = screenWidth * titleWidthMultiplier
        let purchaseLabelHeight: CGFloat = screenHeight * titleHeightMultiplier
        
        purchaseTitleLabel.frame = CGRect(x: 0, y: yOffset,
                                          width: purchaseLabelWidth, height: purchaseLabelHeight)
        purchaseTitleLabel.center.x = horizontalCenter
        purchaseTitleLabel.textAlignment = .center
        purchaseTitleLabel.text = purchaseTitle
        purchaseTitleLabel.numberOfLines = 5
        purchaseTitleLabel.textColor = yellow
        purchaseTitleLabel.font = UIFont(name: "Opificio-RegularRounded", size: titleFontSize)
        self.view.addSubview(purchaseTitleLabel)
        
        skipButton.setTitle("Skip",for: .normal)
        skipButton.titleLabel?.font = UIFont.systemFont(ofSize: skipButtonFontSize)
        skipButton.setTitleColor(self.view.tintColor, for: .normal)
        skipButton.sizeToFit()
        skipButton.titleLabel?.textAlignment = .center
        skipButton.frame.origin.y = screenHeight * skipButtonHeightOffsetMultiplier
        skipButton.frame.origin.x = purchaseTitleLabel.frame.origin.x + purchaseLabelWidth + skipButtonWidthOffset
        let distanceFromEdge = screenWidth - (skipButton.frame.origin.x + skipButton.frame.width)
        if( distanceFromEdge < 10) {
            skipButton.frame.origin.x = screenWidth - (10 + skipButton.frame.width)
        }
        self.view.addSubview(skipButton)
        
        infoButton.frame.origin.y = screenHeight * skipButtonHeightOffsetMultiplier
        infoButton.frame.origin.x = purchaseTitleLabel.frame.origin.x - skipButtonWidthOffset - infoButton.frame.width
        let distanceFromEdge2  = infoButton.frame.origin.x
        if(distanceFromEdge2 < 10) {
            infoButton.frame.origin.x = 10
        }
        self.view.addSubview(infoButton)
        
        
        let purchaseDateWidth: CGFloat = screenWidth * dateWidthMultiplier
        let purchaseDateHeight: CGFloat = screenHeight * dateHeightMultiplier
        
        purchaseDateLabel.frame = CGRect(x: 0,
                                         y: purchaseLabelHeight + yOffset,
                                         width: purchaseDateWidth,
                                         height: purchaseDateHeight)
        purchaseDateLabel.center.x = horizontalCenter
        purchaseDateLabel.textAlignment = .center
        purchaseDateLabel.text = purchaseDate
        purchaseDateLabel.numberOfLines = 5
        purchaseDateLabel.textColor = white
        purchaseDateLabel.font = UIFont(name: "Avenir-Book", size: dateFontSize)
        self.view.addSubview(purchaseDateLabel)
        
        
        let promptHeight: CGFloat = screenHeight * promptHeightMultiplier
        
        promptLabel.frame = CGRect(x: 0,
                                   y: purchaseLabelHeight + purchaseDateHeight + yOffset,
                                   width: purchaseLabelWidth,
                                   height: promptHeight)
        promptLabel.center.x = horizontalCenter
        promptLabel.textAlignment = .center
        promptLabel.text = prompt
        promptLabel.numberOfLines = 7
        promptLabel.textColor = yellow
        promptLabel.font = UIFont(name: "Opificio-RegularRounded", size: promptFontSize)
        self.view.addSubview(promptLabel)
        
        
        let priceViewsHeight: CGFloat = screenHeight * priceViewHeightMultiplier
        
        enterPriceView.frame = CGRect(x: 0,
                                      y: purchaseLabelHeight + purchaseDateHeight + promptHeight + yOffset,
                                      width: screenWidth,
                                      height: priceViewsHeight)
        self.view.addSubview(enterPriceView)
        
        priceField.textAlignment = .right
        priceField.font = UIFont(name: "My-FontRegular", size: priceFontSize)
        priceField.frame = CGRect(x: horizontalCenter-5, y: 0, width: 10, height: priceViewsHeight)
        
        priceField.textColor = white
        priceField.keyboardType = UIKeyboardType.numberPad
        addDoneButtonOnKeyboard()
        
        
        
        priceDollar.text = "$"
        priceDollar.textAlignment = .right
        priceDollar.textColor = yellow
        priceDollar.font = UIFont(name: "My-FontRegular", size: priceFontSize)
        priceDollar.sizeToFit()
        let dollarWidth: CGFloat = priceDollar.frame.width
        
        priceDollar.frame = CGRect(x: priceField.frame.origin.x-dollarWidth,
                                   y: 0,
                                   width: dollarWidth,
                                   height: priceViewsHeight)
        
        enterPriceView.addSubview(priceField)
        enterPriceView.addSubview(priceDollar)
    
        
    }
    
    /**
     Completion function after value has been entered in the spending textfield
     
     - Returns: Void
     */
    func configureSortAnswerLayout() {
        let actualLabelWidth = screenWidth * actualLabelWidthMultiplier
        let actuaLabelHeight = screenHeight * actualLabelHeightMultiplier
        let priorOffset = yOffset + purchaseTitleLabel.frame.height + purchaseDateLabel.frame.height + promptLabel.frame.height + enterPriceView.frame.height
        actualPriceLabel.frame = CGRect(x: horizontalCenter - (actualLabelWidth/2.0),
                                        y: priorOffset,
                                        width: actualLabelWidth,
                                        height: actuaLabelHeight)
        actualPriceLabel.text = actualString
        actualPriceLabel.font = UIFont(name: "Opificio-RegularRounded", size: actualLabelFontSize)
        actualPriceLabel.textAlignment = .center
        actualPriceLabel.textColor = white
        actualPriceLabel.alpha = labelOpacities
        
        let actualViewWidth = screenWidth
        let actualViewHeight = screenHeight * priceViewHeightMultiplier
        actualPriceView.frame = CGRect(x:0, y: priorOffset + actuaLabelHeight, width: actualViewWidth, height: actualViewHeight)
        actualPriceView.alpha = labelOpacities
        
        actualPriceField.isUserInteractionEnabled = false
        actualPriceField.text = String(format: "%.2f", purchasePrice)
        actualPriceField.textColor = white
        actualPriceField.font = UIFont(name: "My-FontRegular", size: priceFontSize)
        actualPriceField.textAlignment = .right
        actualPriceField.sizeToFit()
        
        let actualPriceFieldOriginX = (priceField.frame.origin.x + priceField.frame.width) - actualPriceField.frame.width
        actualPriceField.frame = CGRect(x: actualPriceFieldOriginX,
                                        y:0,
                                        width: actualPriceField.frame.width,
                                        height: actualViewHeight)
        
        
        actualDollar.text = "$"
        actualDollar.textAlignment = .right
        actualDollar.textColor = yellow
        actualDollar.font = UIFont(name: "My-FontRegular", size: priceFontSize)
        actualDollar.sizeToFit()
        let dollarWidth = actualDollar.frame.width
        actualDollar.frame = CGRect(x: actualPriceField.frame.origin.x-dollarWidth,
                                    y: 0,
                                    width: dollarWidth,
                                    height: actualViewHeight)
        
        self.view.addSubview(actualPriceLabel)
        self.view.addSubview(actualPriceView)
        actualPriceView.addSubview(actualPriceField)
        actualPriceView.addSubview(actualDollar)
    }
    
    /**
     Completion function after value has been entered in the spending textfield that is greater than the actual purchase price
     
     - Parameter savings: the amount earned by spending more on the purchase
     
     - Returns: Void
     */
    func configureSavingsLayout(savings: Double) {
        purchaseArray[index].saved = savings
        
        let dispatchTime = DispatchTime.now() + 1.5
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            UIView.animate(withDuration: 0.7, animations: {
                print("INFO: Removing actual price view")
                self.actualPriceView.frame.origin.x = self.screenWidth
                self.actualPriceView.alpha = 0
                if(!self.pending) {
                    self.actualPriceLabel.alpha = 0
                }
            }, completion: { _ in
                print("INFO: Adding the amount saved view")
                self.actualPriceView.frame.origin.x = -self.screenWidth
                
                if(!self.pending) {
                    self.actualPriceLabel.text = "Savings"
                }
                
                self.actualPriceField.text = String(format: "%.2f", savings)
                self.actualPriceField.sizeToFit()
                let fieldOriginX = (self.priceField.frame.origin.x + self.priceField.frame.width) - self.actualPriceField.frame.width
                self.actualPriceField.frame = CGRect(x: fieldOriginX,
                                                     y:0,
                                                     width: self.actualPriceField.frame.width,
                                                     height: self.screenHeight * self.priceViewHeightMultiplier)
                
                self.actualDollar.frame.origin.x = self.actualPriceField.frame.origin.x - self.actualDollar.frame.width
                
                self.savingsPlus.text = "+"
                self.savingsPlus.textAlignment = .right
                self.savingsPlus.textColor = self.white
                self.savingsPlus.font = UIFont(name: "My-FontRegular", size: self.priceFontSize)
                self.savingsPlus.sizeToFit()
                self.savingsPlus.frame = CGRect(x: self.actualDollar.frame.origin.x - self.savingsPlus.frame.width,
                                                y:0,
                                                width: self.savingsPlus.frame.width,
                                                height: self.actualPriceView.frame.height)
                self.actualPriceView.addSubview(self.savingsPlus)
                
                UIView.animate(withDuration: 0.7, delay: 0.3, animations: {
                    self.actualPriceView.frame.origin.x = 0
                    self.actualPriceView.alpha = self.labelOpacities
                    self.actualPriceLabel.alpha = self.labelOpacities
                }, completion: {_ in
                    print("TRACE: Savings animations complete, triggering transition to next View Controller")
                    self.transitionToNext()
                })
            })
        }
    }
    
    /**
     Get the width of the content in the textfield so we can resize it accordingly
     
     - Returns: Void
     */
    func getWidth() -> CGFloat
    {
        let textInField: String = priceField.text!.replacingOccurrences(of: ".", with: "")
        if (lastLength == 4 && priceField.text!.characters.count == 3) {
            priceField.text = textInField
        }
        else if(textInField.characters.count > 2) {
            let firstString = textInField.substring(to: textInField.index(textInField.startIndex, offsetBy: textInField.characters.count - 2)) + "."
            let secondString = textInField.substring(from: textInField.index(textInField.startIndex, offsetBy: textInField.characters.count - 2))
            priceField.text = firstString + secondString
        }
        lastLength = priceField.text!.characters.count
        priceField.sizeToFit()
        if(textInField.characters.count == 0) {
            return 10
        }
        else {
            return priceField.frame.size.width
        }
    }
    
    /**
     Adjust size of Textfield when numbers are added or deleted
     
     - Parameter textField: priceField textField
     
     - Returns: Void
     */
    func textFieldDidChange(textField: UITextField) {
        // Attribution: https://stackoverflow.com/questions/18236661/resize-a-uitextfield-while-typing-by-using-autolayout Resize a textfield when typing
        
        let frieldHeight = screenHeight * priceViewHeightMultiplier
        let fieldWidth = getWidth()
        let newframe = CGRect(x: horizontalCenter-(fieldWidth/2),
                              y: 0,
                              width: fieldWidth,
                              height: frieldHeight)
        priceField.frame = newframe
        priceDollar.frame.origin.x = priceField.frame.origin.x - priceDollar.frame.width
    }
    
    /**
     Add done button to keyboard because numeric keyboard does not have a done button
     
     - Returns: Void
     */
    func addDoneButtonOnKeyboard() {
        // Attribution: https://stackoverflow.com/questions/28338981/how-to-add-done-button-to-numpad-in-ios-8-using-swift Adding Done button in toolbar above numberic Keyboard so we can resign keyboard and enter number into text view
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,
                                                             width: self.screenWidth,
                                                             height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.priceField.inputAccessoryView = doneToolbar
    }
    
    /**
     Helper function for configuration of purchase information display animations
     
     - Parameter priceEntered: string number entered in the textfield
     
     - Returns: Void
     */
    func priceEntered(priceEntered: String) {
        let enteredDouble = Double(priceEntered)
        
        
        if let unwrappedEntered = enteredDouble {
            
            if(unwrappedEntered >= purchasePrice) {
                priceDollar.textColor = green
                priceField.textColor = green
            }
            else {
                priceDollar.textColor = red
                priceField.textColor = red
            }
            
            configureSortAnswerLayout()
            
            if(unwrappedEntered > purchasePrice) {
                let savingsAmt = unwrappedEntered - self.purchasePrice
                configureSavingsLayout(savings: savingsAmt)
            }
            else {
                self.transitionToNext()
            }
        }
        else {
            print("ERROR: Entered value in priceField could not be converted to double, Terminating Application")
        }
    }
    
    
    ///
    /// MARK: - Button Actions
    ///
    
    /**
     Register the text in the spending text field if it's valid, otherwise, display an alert stating that the number entered is not valid
     
     - Returns: Void
     */
    func doneButtonAction() {
        print("INFO: Done pressed, registering text that was entered in the spending textfield")
        var appendToFront: String = ""
        let originalText: String = self.priceField.text!
        if(originalText.characters.count == 0){
            appendToFront = "0.00"
        }
        else if(originalText.characters.count == 1){
            appendToFront = "0.0"
        }
        else if(originalText.characters.count == 2) {
            appendToFront = "0."
        }
        
        self.priceField.text = appendToFront + originalText
        print("INFO: New text in Field\" \(appendToFront+originalText)\" ")
        lastLength = self.priceField.text!.characters.count
        
        priceField.sizeToFit()
        let fieldWidth: CGFloat = priceField.frame.size.width
        let fieldHeight = screenHeight * priceViewHeightMultiplier
        let newframe = CGRect(x: horizontalCenter-(fieldWidth/2),
                              y: 0,
                              width: fieldWidth,
                              height: fieldHeight)
        priceField.frame = newframe
        priceDollar.frame.origin.x = priceField.frame.origin.x - priceDollar.frame.width
        
        let textInField = self.priceField.text!
        let firstText = textInField.substring(to: textInField.index(textInField.startIndex, offsetBy: textInField.characters.count - 3))
        let index = textInField.index(textInField.startIndex, offsetBy: textInField.characters.count - 3)
        let point = textInField[index]
        let secondText = textInField.substring(from: textInField.index(textInField.startIndex, offsetBy: textInField.characters.count - 2))
        
        if(CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: firstText)) && point == "." && CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: secondText))) {
            
            print("INFO: Value entered in field is valid, triggering Purchase information animation sequences")
            
            self.priceField.resignFirstResponder()
            self.priceField.isUserInteractionEnabled = false
            
            priceEntered(priceEntered: priceField.text!)
        }
        else {
            print("INFO: Value entered in field is not a valid number, triggering a UIAlert to notify the user to enter a valid number")
            let alert = UIAlertController(title: "Invalid Input",
                                          message: "You must enter a number with two decimal places",
                                          preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    /**
     Diplay Sort Game instructions when Info button is tapped
     
     - Parameter sender: the Info button
     
     - Returns: Void
     */
    func infoTapped(sender: UIButton!) {
        let alert = UIAlertController(title: "How to Play",
                                      message: "Enter how much you would like to spend from your budget for the purchase listed on the Screen. If you enter an amount more than what the price of the purchase was, then the difference will be added to your savings. If you enter an amount less, then the price of the purchase is deducted from your budget as normal, but you'll earn no savings. Press skip to automatically sort every purchase at it's actual value",
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    /**
     Automatically transition to Main app view when skip button is tapped
     
     - Parameter sender: the "skip" button
     
     - Returns: Void
     */
    func skipTapped(sender: UIButton!) {
        transitionToMain()
    }
    
    
    ///
    /// MARK: - Notification Center
    ///
    
    /**
     Raise view and lower buttons if necessary when keyboard is raised so all fields are accessible
     
     - Parameter notificaion: KeyboardWillShow notification
     
     - Returns: Void
     */
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                print("TRACE: Raising main view to make room for keyboard for sortVC with index \(index)")
                let keyboardHeight = keyboardSize.height
                let keyboardTop = screenHeight - keyboardHeight
                let enterPriceBottom = enterPriceView.frame.origin.y + enterPriceView.frame.height
                let moveDiff = keyboardTop - (enterPriceBottom + 5)
                if(moveDiff < 0) {
                    self.view.frame.origin.y += moveDiff
                    
                    if(skipButton.frame.origin.y < (-moveDiff)) {
                        skipButton.frame.origin.y = promptLabel.frame.origin.y
                        infoButton.frame.origin.y = promptLabel.frame.origin.y
                    }
                }
            }
        }
    }
    
    /**
     Lower View and raise buttons if view was raised to make room for keyboard
     
     - Parameter notificaion: KeyBoardWillHide notification
     
     - Returns: Void
     */
    func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0{
            self.view.frame.origin.y = 0
            
            skipButton.frame.origin.y = screenHeight * skipButtonHeightOffsetMultiplier
            infoButton.frame.origin.y = screenHeight * skipButtonHeightOffsetMultiplier
            print("TRACE: Lowering main view as NUMBER keyboard disappears")
        }
    }
    
    ///
    /// MARK: - Navigation
    ///
    
    /**
     Transition to main app view from SortViewController
     
     - Returns: Void
     */
    func transitionToMain() {
        NotificationCenter.default.removeObserver(self)
        defaults.synchronize()
        defaults.set(nil, forKey: "unsortedWhenTerminated")
        defaults.synchronize()
        
        registerSavings(purchases: self.purchaseArray)
        
        let storyboard: UIStoryboard = UIStoryboard(name:"Main", bundle: Bundle.main)
        let mainView =  storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
        
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        present(mainView, animated: false)
    }
    
    /**
     Transition to the next ViewController. function logic determines whether we transition to another SortVC or the main app VC
     
     - Returns: Void
     */
    func transitionToNext() {
        let nextIndex = index + 1
        NotificationCenter.default.removeObserver(self)
        if(nextIndex < purchaseArray.count) {
            print("INFO: Not at the last purchase, triggering transition to the SortViewController for the next purchase")
            let sortView = SortViewController()
            sortView.purchaseArray = self.purchaseArray
            sortView.index = nextIndex
            sortView.transitioningDelegate = self
            sortView.modalPresentationStyle = .custom
            let dispatchTime = DispatchTime.now() + 1.2
            DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
                self.present(sortView, animated: true, completion: nil)
            }
        }
        else {
            print("INFO: End of Purchases reached, triggering transition to Main app View")
            let dispatchTime = DispatchTime.now() + 1.2
            DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
                self.transitionToMain()
            }
        }
    }
    
    /**
     Add all earned savings to totalSavings before state transition or transition to Main App view
     
     - Parameter purchases: Array of purchases to add earned savings from
     
     - Returns: Void
     */
    func registerSavings(purchases: [Purchase]) {
        var savedSavings = defaults.double(forKey: "savedSavings")
        
        for purchased in purchases {
            savedSavings += purchased.saved
        }
        
        defaults.set(savedSavings, forKey: "savedSavings")
        
        defaults.synchronize()
    }
    
    
    ///
    /// MARK: - App State Handlers
    //
    
    /**
     Save all unsorted purchases to user defaults and register current earned savings to total savings in case app is terminated while in the background
     
     - Parameter notificaion: ApplicationWillResignActive notification
     
     - Returns: Void
     */
    func resigningActive(notification: NSNotification) {
        print("INFO: Resigning from Active State, App transitioning to Background, may be terminated soon")
        purchaseArray[index].saved = 0
        
        var sortedArray: [Purchase] = []
        var unsortedArray: [Purchase] = []
        
        for i in 0..<self.purchaseArray.count {
            if(i < self.index) {
                sortedArray.append(self.purchaseArray[i])
            }
            else {
                unsortedArray.append(self.purchaseArray[i])
            }
        }
        
        if(unsortedArray.isEmpty) {
            
            defaults.set(nil, forKey: "unsortedWhenTerminated")
        }
        
        else {
            let archiver = NSKeyedArchiver.archivedData(withRootObject: unsortedArray)
            defaults.set(archiver, forKey: "unsortedWhenTerminated")
            defaults.synchronize()
        }
        defaults.synchronize()
        
        self.priceField.resignFirstResponder()
        
        registerSavings(purchases: sortedArray)
        
        self.purchaseArray = unsortedArray
        self.index = 0
        self.purchase = self.purchaseArray[0]
        
        
    }
    
    /**
     Remove all observers to prepare for app termination
     
     - Parameter notificaion: ApplicationWillTerminate notification
     
     - Returns: Void
     */
    func terminating(notification: NSNotification) {
        print("INFO: Terminating App. removing all observers and sutting down app")
        //NOTE: I recall seeing in some Stack overflow post that you should remove observers before terminating app, but I forgot which one. I don't know if I could actually do this but I'm doing it anyway
        NotificationCenter.default.removeObserver(self)
    }
    
    /**
     Reconfigure layout  when app resmes from background
     
     - Parameter notificaion: ApplicationDidBecomeActive notification
     
     - Returns: Void
     */
    func returningToActive(notification: NSNotification) {
        print("INFO: Returning to Active State. App returning as main view from background")
        loadLayout()
    }
}
