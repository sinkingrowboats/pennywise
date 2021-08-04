//
//  ConnectionServices.swift
//  PennyWise
//
//  Created by Samantha Rey on 8/26/17.
//  Copyright © 2017 Samantha Rey. All rights reserved.
//

import UIKit

/**
 Connection Services Class, handles all methods for any data methods that require an internet connection
 */
class ConnectionServices: NSObject {
    //
    // MARK: - Properties
    //
    
    /// dataSession object to initiate the connection
    let dataSession = URLSession(configuration: .default)
    
    /// dataTask object to perform the data task
    var dataTask: URLSessionDataTask?
    /// errorMessage string to detect errors with the dataTask
    var errorMessage = ""
    
    //
    // MARK: - Custom Methods
    //
    
    /**
     retrieve Purchase data. NOTE: This function only simulates a connection test for the time being and retrieves a static array of purchase data provided by the DummyPurchaseData Clas
     
     - Parameter completion: completion function to trigger after data has been retrieved
     
     - Returns: Void
     */
    func getResultData(completion: @escaping ([Purchase], String) -> ()) {
        print("NOTE: This function only simulates a connection test for the time being and retrieves a static array of purchase data provided by the DummyPurchaseData Clas")
        dataTask?.cancel()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        errorMessage = ""
        
        let queryURLOpt = URL(string: "https://www.google.com")
        guard let queryURL = queryURLOpt else{
            self.errorMessage += "Bad request URL. "
            DispatchQueue.main.async {
                completion([], self.errorMessage)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            return
        }
        
        print("INFO: Querying Google for connection test")
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: queryURL as URL)
        dataTask = dataSession.dataTask(with: urlRequest as URLRequest) { data, response, error in
            defer {self.dataTask = nil}
            
            if let error = error {
                print("INFO: An error occurred while attempting to connect to the data source")
                self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                DispatchQueue.main.async {
                    completion([], self.errorMessage)
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
            else if let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                
                print("INFO: Connection Test Successful, returning preset purchase array to simulate successful connection")
                
                
                DispatchQueue.main.async {
                    completion(DummyPurchaseData.returnDummyPurchaseArray(), "")
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
                return
            }
                
            else {
                print("INFO: Status Code not 200s indicates an unsucessful connection test, returning as error")
                self.errorMessage += "Bad response\n"
                DispatchQueue.main.async {
                    completion([], self.errorMessage)
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
        }
        
        dataTask?.resume()
    }

}
