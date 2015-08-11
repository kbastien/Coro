//
//  PickPlaylistViewController.swift
//  Coro
//
//  Created by Kevin Bastien on 7/15/15.
//  Copyright (c) 2015 Kevin Bastien. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class PickPlaylistViewController: UIViewController, CLLocationManagerDelegate {
    
    var session:SPTSession!
    var playlist = ViewController()
    
    //location variables
    let locationManager = CLLocationManager()
    let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D"), identifier: "Coro iBeacon")
    let greenLight = UIColor(red: 0, green: 1, blue: 0, alpha: 1)
    let redLight = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playlist.userPlaylist()
        playlist.userData()
        
        locationManager.delegate = self
        
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startRangingBeaconsInRegion(region)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func postTrack(){
        let postsEndpoint = "https://api.spotify.com/v1/users/1210394933/playlists/0hQrE9qqgB2AiRPZmDG8Uk/tracks?uris=spotify:track:6wf85LERx5my0RsMh6tSkT&scope=playlist-modify-public&playlist-modify-private"
        let headers = ["Content-Type": "application/json", "Authorization": "Bearer \(playlist.auth.session.accessToken)"]
        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = headers
        Alamofire.request(.POST, postsEndpoint, parameters: nil , encoding: .JSON)
            .responseJSON { (request, response, data, error) in
                if let anError = error
                {
                    // got an error in getting the data, need to handle it
                    println("error calling POST on /posts")
                    println(error)
                }
                else if let data: AnyObject = data
                {
                    // handle the results as JSON
                    let post = JSON(data)
                    // to make sure it posted, print the results
                    println("The post is: " + post.description)
                }
        }
            
    }
    
    func deleteTrack(){
        let deleteEndpoint = "https://api.spotify.com/v1/users/1210394933/playlists/0hQrE9qqgB2AiRPZmDG8Uk/tracks"
        let headers = ["Content-Type": "application/json", "Accept": "application/json", "Authorization": "Bearer \(playlist.auth.session.accessToken)"]
        var params = ["tracks": [["uri": "spotify:track:6wf85LERx5my0RsMh6tSkT"]]]
        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = headers
        Alamofire.request(.DELETE, deleteEndpoint, parameters: params , encoding: .JSON)
            .responseJSON { (request, response, data, error) in
                if let anError = error
                {
                    // got an error in getting the data, need to handle it
                    println("error calling DELETE on /posts")
                    println(error)
                }
                else if let data: AnyObject = data
                {
                    // handle the results as JSON
                    let delete = JSON(data)
                    // to make sure it posted, print the results
                    println("The post is: " + delete.description)
                }
        }
    }
    
    //user location and beacon methods
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        //filtering out all unknown beacons
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.Unknown }
        if (knownBeacons.count > 0) {
            let closestBeacon = knownBeacons[0] as! CLBeacon
            if(closestBeacon.proximity.rawValue == 1){
                self.view.backgroundColor = greenLight
                var postCount = 1;
                if(postCount < 2){
                    postTrack()
                    postCount += 1
                }
            }
            else {
                self.view.backgroundColor = redLight
                var deleteCount = 1;
                if(deleteCount < 2){
                    deleteTrack()
                    deleteCount += 1
                }
            }
        }
        println(knownBeacons)
    }
    
}