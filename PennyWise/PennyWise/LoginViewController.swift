//
//  ViewController.swift
//  PennyWise
//
//  Created by Samantha Rey on 8/14/17.
//  Copyright © 2017 Samantha Rey. All rights reserved.
//

import UIKit

/// UITableViewController file for the login/registration screen
class LoginViewController: UIViewController, UITextFieldDelegate, UIViewControllerTransitioningDelegate {

    ///
    /// MARK: - Miscellaneous properties
    ///
    
    /// MARK: Connection Properties
    let connectionService = ConnectionServices()
    var newUnsortedPurchases: [Purchase] = []
    
    /// MARK:User Defaults
    let defaults = UserDefaults.standard
    
    /// MARK: Transition Properties
    let circleTransition = CircularTransition()
    
    
    ///
    /// MARK: - Layout Properties
    ///
    var width: CGFloat = 0
    var height: CGFloat = 0
    var screenWidth: CGFloat = 0
    var screenHeight: CGFloat = 0
    var maxheight: CGFloat = 0
    
    
    ///
    /// MARK: - Outlet Variables
    ///
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var registerView: UIView!
    
    @IBOutlet weak var loginBottomY: NSLayoutConstraint!
    @IBOutlet weak var registerBottomY: NSLayoutConstraint!
    
    @IBOutlet weak var newUserButton: UIButton!
    @IBOutlet weak var existingUserButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var loginUserField: UITextField!
    @IBOutlet weak var loginPassField: UITextField!
    @IBOutlet weak var registerUserField: UITextField!
    @IBOutlet weak var registerPassField: UITextField!
    @IBOutlet weak var registerConfirmField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("TRACE: Beginning Load of LoginViewController")
        
        /// MARK: Adding functions to the buttons on the LoginViewController
        
        /// Login User
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        
        /// Register User
        registerButton.addTarget(self, action: #selector(register), for: .touchUpInside)
        
        /// Switch between login and register view controllers
        newUserButton.addTarget(self, action: #selector(switchToRegister), for: .touchUpInside)
        existingUserButton.addTarget(self, action: #selector(switchToLogin), for: .touchUpInside)
        
        
        /// MARK: Initializing textfields
        
        initializeAllTextFieldDelegates()
        
        print("INFO: Retrieving user and password preferences to pre populate the textfields if user provided user and passord saved strings")
        if let userfield = defaults.object(forKey: "user_field") as? String {
            loginUserField.text = userfield//saved username
        }
        else {
            loginUserField.text = ""
        }
        if let passfield = defaults.object(forKey: "pass_field") as? String {
            loginPassField.text = passfield//saved username
        }
        else {
            loginPassField.text = ""
        }
        
        /// MARK: Adjusting Layout
        
        width = self.view.frame.width
        height = self.view.frame.height
        
        screenWidth = UIScreen.main.bounds.width
        screenHeight = UIScreen.main.bounds.height
        
        if(screenWidth > screenHeight) {
            maxheight = screenWidth/2
        }
        else {
            maxheight = screenHeight/2
        }
        registerBottomY.constant = maxheight
        
        
        /// MARK: Notification Center Observers
        
        ///Observers to adjust main view for keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.adjustIfKeyboardUp), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        
        print("TRACE: Finished Load of LoginViewController")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    ///
    /// MARK: UITextFieldDelegate Methods
    ///
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        print("INFO: Resigning Keyboard as first responder")
        return true
    }
    
    
    ///
    /// MARK: - UIViewControllerTransitioningDelegate Methods
    ///
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
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
    
    /**
     Initialize the delegate properties for all of the textfields on the login page
     the scrollView
     
     - Returns: Void
     */
    func initializeAllTextFieldDelegates() {
        self.loginUserField.tag = 1
        self.loginUserField.delegate = self
        self.loginPassField.tag = 2
        self.loginPassField.delegate = self
        
        self.registerUserField.tag = 3
        self.registerUserField.delegate = self
        self.registerPassField.tag = 4
        self.registerPassField.delegate = self
        self.registerConfirmField.tag = 5
        self.registerConfirmField.delegate = self
    }
    
    /**
     Trigger registration of a new user. NOTE: Register funcitonality is not yet available, this will automatically just transition to  the Main App view without sorting
     
     - Returns: Void
     */
    func register() {
        print("INFO: \"Register\" button pressed")
        print("NOTE: Register funcitonality is not yet available, this will automatically just transition to  the Main App view without sorting")
        transitionToApp(sort: false)
     }
    
    /**
     Trigger login of an existing user. NOTE: Login functionality not yet available, instead, any press to login is treated as a valid login of single user and triggers the rest of the login sequence
     
     - Returns: Void
     */
    func login() {
        print("INFO: \"Login\" button pressed")
        print("NOTE: Login functionality not yet available, instead, any press to login is treated as a valid login of single user and triggers the rest of the login sequence")
        transitionToApp(sort: true)
     }
    
    /**
     Switch from currently displayed Restration view to Login View
     
     - Parameter sender: "Login as existing user" Button
     
     - Returns: Void
     */
    func switchToLogin(sender: UIButton!) {
        // Attribution: https://stackoverflow.com/questions/38575410/swift-animation-with-constraint how to animate constraint changes
        
        print("INFO: \"Login as Existing User\" button pressed")
        print("TRACE: Switching current view from Registration to Login")
        self.view.layoutIfNeeded()
        
        self.registerBottomY.constant = maxheight
        UIView.animate(withDuration: 0.4, animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.loginBottomY.constant = 0
                UIView.animate(withDuration: 0.4, animations: {
                    self.view.layoutIfNeeded()
                }, completion: nil)
        })
    }
    
    /**
     Switch from currently displayed Login view to Registration View
     
     - Parameter sender: "Register as new user" Button
     
     - Returns: Void
     */
    func switchToRegister(sender: UIButton!) {
        print("INFO: \"Register as New User\" button pressed")
        print("TRACE: Switching current view from Login to Registration")
        self.view.layoutIfNeeded()
        self.loginBottomY.constant = maxheight
        UIView.animate(withDuration: 0.4, animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
                self.registerBottomY.constant = 0
                UIView.animate(withDuration: 0.4, animations: {
                    self.view.layoutIfNeeded()
                }, completion: nil)
        })
    }
    
    
    ///
    /// MARK: - Notification Center Methods
    ///
    
    /**
     Raise the view if the keyboard shows
     
     - Parameter notification: "KeyboardWillShow" event
     
     - Returns: Void
     */
    func keyboardWillShow(notification: NSNotification) {
        // Attribution: https://stackoverflow.com/questions/26070242/move-view-with-keyboard-using-swift How to adjust view when keyboard raises
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                print("TRACE: Raising main view to make room for keyboard")
                self.view.frame.origin.y -= keyboardSize.height
            }
        }        
    }
    
    /**
     Lower the view if the keyboard disappears
     
     - Parameter notification: "KeyboardWillHide" event
     
     - Returns: Void
     */
    func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0{
            self.view.frame.origin.y = 0
                print("TRACE: Lowering main view as keyboard disappears")
        }
    }
    
    /**
     Adjust the view if the screen rotates when the keyboard is up
     
     - Parameter notification: "KeyboardChangeFrame" event
     
     - Returns: Void
     */
    func adjustIfKeyboardUp(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            print("TRACE: Readjusting view with keyboard after device orientation changed")
            self.view.frame.origin.y = (0-keyboardSize.height)
        }
    }
    
    
    ///
    /// MARK: - Navigation
    ///
    
    /**
     Transition to next view in the app
     
     - Parameter sort: if sort is TRUE, then app automatically transitions the Main app view, else, the login sequence is triggered, which will then determine the next view
     
     - Returns: Void
     */
    func transitionToApp(sort: Bool) {
        print("TRACE: Segueing to application views")
        if(sort) {
            print("INFO: Moving to SortViewController")
            connectionService.getResultData(completion: prepareTransition)
        }
        else {
            NotificationCenter.default.removeObserver(self)
            let storyboard: UIStoryboard = UIStoryboard(name:"Main", bundle: Bundle.main)
            let mainView =  storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
            
            let transition = CATransition()
            transition.duration = 0.4
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            self.view.window!.layer.add(transition, forKey: kCATransition)
            
            present(mainView, animated: false)
        }
    }

    /**
     Completion function for connectionService. If the data retrieval was successful, all new purchases are added to be sorted. If retrieval fails, then only data that was already stored from the last session will be used by the app
     NOTE: Currently the data retrieval is only modeled by a connection test to simulate data retrieval, and the actual data provided by this function is statically provided by the DummyPurchaseData.swift file
     
     - Parameter newPurchases: Array of Purchase objects retrieved by ConnectionService
     - Parameter errorMessage: message detailing error from ConnectionService. If errorMessage is empy then data retrieval was successful without error
     
     - Returns: Void
     */
    func prepareTransition(newPurchases: [Purchase], errorMessage: String) {
        print("NOTE: Currently the data retrieval is only modeled by a connection test to simulate data retrieval, and the actual data provided by this function is statically provided by the DummyPurchaseData.swift file")
        if(!errorMessage.isEmpty) {
            let alert = UIAlertController(title: "Error",
                                          message: "Bad Response/Request. Connection Failed. Using data from last session.",
                                          preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default) { (action) in
                let emptyarray: [Purchase] = []
                self.newUnsortedPurchases = emptyarray
                self.passDataTransition()
            }
            
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
            print("CONNECTION ERROR:\(errorMessage)")
        }
        else{
            newUnsortedPurchases = newPurchases
            passDataTransition()
        }
    }
    
    /**
     Helper function of prepareTransition. Transitions to sort views if there are any unsortedPurchases, either new or already saved to app. Otherwise, move directly to Main app view
     
     - Returns: Void
     */
    func passDataTransition() {
        var unsortedPurchases = getUnsortedWhenTerminated()
        unsortedPurchases.append(contentsOf: newUnsortedPurchases)
        
        NotificationCenter.default.removeObserver(self)
        
        if(unsortedPurchases.isEmpty) {
            NotificationCenter.default.removeObserver(self)
            let storyboard: UIStoryboard = UIStoryboard(name:"Main", bundle: Bundle.main)
            let mainView =  storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
            
            let transition = CATransition()
            transition.duration = 0.4
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            self.view.window!.layer.add(transition, forKey: kCATransition)
            
            present(mainView, animated: false)
        }
            
        else {
            let sortView = SortViewController()
            sortView.purchaseArray = unsortedPurchases
            sortView.index = 0
            sortView.transitioningDelegate = self
            sortView.modalPresentationStyle = .custom
            self.present(sortView, animated: true, completion: nil)
        }
    }
    
    /**
     Retrieve any purchases that were unsorted when the app terminated so they can try and be sorted again
     
     - Returns: Void
     */
    func getUnsortedWhenTerminated() -> [Purchase] {
        defaults.synchronize()
        if let data = defaults.object(forKey: "unsortedWhenTerminated"){
            let object = NSKeyedUnarchiver.unarchiveObject(with: (data as! NSData) as Data)
            if let purchaseArr = object as? [Purchase] {
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
}

