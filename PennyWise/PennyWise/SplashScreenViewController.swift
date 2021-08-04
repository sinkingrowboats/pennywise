//
//  SplashScreenViewController.swift
//  PennyWise
//
//  Created by Samantha Rey on 8/18/17.
//  Copyright © 2017 Samantha Rey. All rights reserved.
//

import UIKit

/// UITableViewController file for the app Splash Screen
class SplashScreenViewController: UIViewController {
    ///
    /// MARK: - Defaults
    ///
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Checking if initial launch
        if (defaults.object(forKey: "Initial Launch") as? NSDate) != nil {
            print("TRACE: Not initial launch")
        }
        else {
            
            print("INFO: Initial launch")
            print("TRACE: Resgistering initial values to stored properties")
            
            let initialLaunch = NSDate()
            defaults.set(initialLaunch, forKey: "Initial Launch")
            
            let developer = "Samantha Tai-yang Rey"
            defaults.set(developer, forKey: "developer")
            
            let newSavings: Double = 0.0
            defaults.set(newSavings, forKey: "savedSavings")
        }
        
        defaults.synchronize()

        // Attribution: https://stackoverflow.com/questions/24170282/swift-performselector-withobject-afterdelay perform function after specific time delay using threading
        let dispatchTime = DispatchTime.now() + 1.5
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            self.performSegue(withIdentifier: "starting", sender: self)
            print("INFO: Transitioning to LoginViewController")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
