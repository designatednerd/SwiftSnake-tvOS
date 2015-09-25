//
//  Randomizer.swift
//  SwiftSnake
//
//  Created by Ellen Shapiro (Vokal) on 9/25/15.
//  Copyright © 2015 Vokal. All rights reserved.
//

import Foundation

struct Randomizer {
    
    /**
     Because generating a random number takes a stupid number of keystrokes.
     
     - parameter seed: The seed for the randomizer
     
     - returns: The random number.
     */
    static func randomIntWithSeed(seed: Int) -> Int {
        return Int(arc4random_uniform(UInt32(seed)))
    }
}