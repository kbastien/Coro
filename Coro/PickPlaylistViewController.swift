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
    var playlistArray = [String]()
    var deleteArray = [String]()
    var hasDoneRequestAlready = true
    
    //location variables
    let locationManager = CLLocationManager()
    let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D"), identifier: "Coro iBeacon")
    let greenLight = UIColor(red: 0, green: 1, blue: 0, alpha: 1)
    let redLight = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
    let blueLight = UIColor(red: 0, green: 0, blue: 1, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playlist.userPlaylist()
        playlist.userData()
        getPlaylistTracks()
        
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
    
    func getPlaylistTracks(){
        let endpoint = "https://api.spotify.com/v1/users/1210394933/playlists/3wBJQcbsrdJB1cgctsVJxS/tracks"
        let headers = ["Content-Type": "application/json", "Authorization": "Bearer \(playlist.auth.session.accessToken)"]
        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = headers
        Alamofire.request(.GET, endpoint, parameters: nil , encoding: .JSON)
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
                    let getPlaylistData = JSON(data)
                    // to make sure it posted, print the results
//                    println("The get is: " + getPlaylistData.description)
                    for (key, value) in getPlaylistData["items"] {
                        self.playlistArray.append(value["track"]["uri"].string!)
                    }
                }
        }
        
    }
    
    func postTrack(){
        let postsEndpoint = "https://api.spotify.com/v1/users/1210394933/playlists/0hQrE9qqgB2AiRPZmDG8Uk/tracks"
        let headers = ["Content-Type": "application/json", "Authorization": "Bearer \(playlist.auth.session.accessToken)"]
        let params = ["uris": playlistArray]
        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = headers
        Alamofire.request(.POST, postsEndpoint, parameters: params , encoding: .JSON)
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
        
        var params = ["tracks": playlistArray.map({
            ["uri": "\($0)"]
        })]
        
        println("THIS IS THE DELETE PARAMS: \(params)")
        
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
                    println("The delete is: " + delete.description)
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
                if(hasDoneRequestAlready){
                    postTrack()
                    self.view.backgroundColor = blueLight
                    hasDoneRequestAlready = false
                }
            }
            else {
                self.view.backgroundColor = redLight
                deleteTrack()
                hasDoneRequestAlready = true
            }
        }
        println(knownBeacons)
    }
    
}