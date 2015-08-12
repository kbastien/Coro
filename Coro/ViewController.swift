//
//  ViewController.swift
//  Coro
//
//  Created by Kevin Bastien on 7/9/15.
//  Copyright (c) 2015 Kevin Bastien. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    let kClientID = "24f5052d223b45068950c8ffecac1f45"
    let kCallbackURL = "coro://returnafterlogin"
    let kTokenSwapURL = "http://coro.herokuapp.com/swap"
    let kTokenRefreshServiceURL = "http://coro.herokuapp.com/refresh"
    let UserDefaultsKey = "sessionSpotify"
    var session : SPTSession!
    let auth = SPTAuth.defaultInstance()

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
        
        if let session = auth.session {
            if !session.isValid() {
                SPTAuth.defaultInstance().renewSession(session, callback: { (error: NSError!, session: SPTSession!) -> Void in
                    self.auth.session = session
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
        if let navigation = segue.destinationViewController as? UINavigationController {
            if let pc = navigation.viewControllers.first as? PickPlaylistViewController {
                if (sender as! SPTSession).isValid() {
                    pc.session = self.auth.session
                }
            }
        }
        
    }
    
    //Get users playlist info
    func userPlaylist() -> [String]? {
        var checkError:NSErrorPointer
        var library:[String]?
        
        SPTYourMusic.savedTracksForUserWithAccessToken(auth.session.accessToken, callback: { (error, result) -> Void in
            if error != nil {
                print("Error while getting user's saved tracks: \(error)")
                return
            }
            if let resultObj = result as? [String] {
                println("\(resultObj)");
            } else {
                print("No Tracks")
            }
        })
        return library
    }
    
    /*
    this methods purpose is to retrieve the user's data and print out users info
    */
    func userData() {
        let userReq = SPTUser.createRequestForCurrentUserWithAccessToken(SPTAuth.defaultInstance().session.accessToken, error: nil)
        SPTRequest.sharedHandler().performRequest(userReq, callback: { (error: NSError!, response: NSURLResponse!, data: NSData!) -> Void in
            if error != nil {
                print("Retrieving user data was unsuccessful: \(error)")
                return
            }
            let user = SPTUser(fromData: data, withResponse: response, error: nil)
            let username = user.displayName
            NSLog("User's name: \(username)")
            let canonicalUserName = user.canonicalUserName
            NSLog("User's canonical name: \(canonicalUserName)")
            let territory = user.territory
            NSLog("User's Territory: \(territory)")
            let email = user.emailAddress
            NSLog("User's email: \(email)")
            let uri = user.uri
            NSLog("URI: \(uri)")
            let sharingURL = user.sharingURL
            NSLog("Share URL: \(sharingURL)")
            let followers = user.followerCount
            NSLog("Number of followers: \(followers)")
        })
    }
    
}

