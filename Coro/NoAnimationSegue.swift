//
//  NoAnimationSegue.swift
//  Coro
//
//  Created by Kevin Bastien on 7/10/15.
//  Copyright (c) 2015 Kevin Bastien. All rights reserved.
//

import Foundation
import UIKit

class NoAnimationSegue: UIStoryboardSegue {
    override func perform() {
        let source = sourceViewController as! UIViewController
        if let navigation = source.navigationController {
            navigation.pushViewController(destinationViewController as! UIViewController, animated: false)
        }
    }
}