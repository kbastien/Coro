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

class PickPlaylistViewController: UIViewController {
    
    var session:SPTSession!
    var playlist = ViewController()
    @IBOutlet weak var addSongBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playlist.userPlaylist()
        playlist.userData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func postTrack(){
        let postsEndpoint = "https://api.spotify.com/v1/users/1210394933/playlists/0hQrE9qqgB2AiRPZmDG8Uk/tracks?uris=spotify:track:6wf85LERx5my0RsMh6tSkT&scope=playlist-modify-public&playlist-modify-private"
        let headers = ["Content-Type": "application/json", "Authorization": "Bearer \(playlist.auth.session.accessToken)"]
        let scopes = "playlist-modify-public%20playlist-modify-private"
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
    
    @IBAction func addButtonPressed(sender: AnyObject) {
        postTrack()
    }
    
}