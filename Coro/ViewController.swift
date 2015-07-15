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
    let UserDefaultsKey = "sessionSpotify"
    var session : SPTSession!

    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userSessionObj = NSUserDefaults.standardUserDefaults().objectForKey(UserDefaultsKey) as? NSData {
            let userSession = NSKeyedUnarchiver.unarchiveObjectWithData(userSessionObj) as! SPTSession
            
            if userSession.isValid() {
                loginReceived()
            }
            
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        loginReceived()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Log in functions
    //###########################################################


    @IBAction func loginWithSpotify(sender: AnyObject) {
        openLogin()
    }
    
    private func openLogin() {
        var authvc = SPTAuthViewController.authenticationViewController()
        authvc.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        authvc.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        authvc.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
        self.definesPresentationContext = true
        self.presentViewController(authvc, animated: false, completion: nil)
    }
    
    func loginReceived () {
        
        let auth = SPTAuth.defaultInstance()
        
        if let session = auth.session {
            if !session.isValid() {
                SPTAuth.defaultInstance().renewSession(session, callback: { (error: NSError!, session: SPTSession!) -> Void in
                    auth.session = session
                    if error != nil {
                        println("Error refreshing session: \(error)")
                    }
                })
            } else {
                println("Session is valid, user is logged in 😎!!")
                auth.session = session
                self.performSegueWithIdentifier("LoginReceived", sender: session)
            }
        }
    }
    
    //###########################################################
    
    
    //SPTAuthViewDelegate
    //###########################################################
    func authenticationViewController(authenticationViewController: SPTAuthViewController!, didFailToLogin error: NSError!) {
        println("login failed: \(error)")
    }
    
    func authenticationViewController(authenticationViewController: SPTAuthViewController!, didLoginWithSession session: SPTSession!) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let userSession = NSKeyedArchiver.archivedDataWithRootObject(session)
        userDefaults.setObject(userSession, forKey: UserDefaultsKey)
        userDefaults.synchronize()

        authenticationViewController.clearCookies(nil)
    }
    
    func authenticationViewControllerDidCancelLogin(authenticationViewController: SPTAuthViewController!) {
        println("Login Cancelled")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //any pre-segue stuff goes in here
        if let navigation = segue.destinationViewController as? UINavigationController {
            if let pc = navigation.viewControllers.first as? PickPlaylistViewController {
                if (sender as! SPTSession).isValid() {
                    pc.session = (sender as! SPTSession)
                }
            }
        }
        
    }

}

