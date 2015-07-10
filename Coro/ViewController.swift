//
//  ViewController.swift
//  Coro
//
//  Created by Kevin Bastien on 7/9/15.
//  Copyright (c) 2015 Kevin Bastien. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let kClientID = "24f5052d223b45068950c8ffecac1f45"
    let kCallbackURL = "coro://returnafterlogin"
    let kTokenSwapURL = "http://coro.herokuapp.com/swap"
    let kTokenRefreshServiceURL = "http://coro.herokuapp.com/refresh"

    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        loginButton.hidden = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateAfterFirstLogin", name: "loginSuccessful", object: nil)
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if let sessionObj:AnyObject = userDefaults.objectForKey("SpotifySession"){ //session available
            let sessionDataObj = sessionObj as! NSData
            let session = NSKeyedUnarchiver.unarchiveObjectWithData(sessionDataObj) as! SPTSession
            
//            if !session.isValid() {
//                SPTAuth.defaultInstance().renewSession(session, callback: {(error:NSError!, session: SPTSession!) -> Void in
//                    if error == nil {
//                        let sessionData = NSKeyedArchiver.archivedDataWithRootObject(session)
//                        userDefaults.setObject(sessionData, forKey: "SpotifySession")
//                        userDefaults.synchronize()
//                        
//                    }else {
//                        println("error refresh")
//                    }
//                })
//            }
            
            
        }else {
            loginButton.hidden = false
        }
    }

    func updateAfterFirstLogin() {
        loginButton.hidden = true
    }

    @IBAction func loginWithSpotify(sender: AnyObject) {
        
        let loginURL = SPTAuth.loginURLForClientId(kClientID, withRedirectURL: NSURL(string: kCallbackURL), scopes: [SPTAuthStreamingScope], responseType: "token")
        
        UIApplication.sharedApplication().openURL(loginURL)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

