//
//  AppDelegate.swift
//  Coro
//
//  Created by Kevin Bastien on 7/9/15.
//  Copyright (c) 2015 Kevin Bastien. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let kClientID = "24f5052d223b45068950c8ffecac1f45"
    let gimbalKey = "601000c8-1b45-49aa-91b4-149fced21e77"
    let kCallbackURL = "coro://returnafterlogin"
    let kTokenSwapURL = "http://coro.herokuapp.com/swap"
    let kTokenRefreshServiceURL = "http://coro.herokuapp.com/refresh"
    let UserDefaultsKey = "sessionSpotify"
    
    var window: UIWindow?

    var session: SPTSession?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        Gimbal.setAPIKey(gimbalKey, options: nil)
        
        let auth = SPTAuth.defaultInstance()
        auth.clientID = kClientID
        auth.redirectURL = NSURL(string: kCallbackURL)
        auth.requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope,SPTAuthPlaylistModifyPrivateScope,SPTAuthUserFollowModifyScope, SPTAuthUserFollowReadScope,SPTAuthUserLibraryModifyScope,SPTAuthUserLibraryReadScope,SPTAuthUserReadBirthDateScope,SPTAuthUserReadEmailScope,SPTAuthUserReadPrivateScope]
        auth.sessionUserDefaultsKey = UserDefaultsKey
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

