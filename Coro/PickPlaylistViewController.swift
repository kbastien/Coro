//
//  PickPlaylistViewController.swift
//  Coro
//
//  Created by Kevin Bastien on 7/15/15.
//  Copyright (c) 2015 Kevin Bastien. All rights reserved.
//

import Foundation
import UIKit

class PickPlaylistViewController: UIViewController {
    
    var session:SPTSession!
    var playlist = ViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playlist.userPlaylist()
        playlist.userData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}