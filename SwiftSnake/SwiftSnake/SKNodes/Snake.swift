//
//  Snake.swift
//  SwiftSnake
//
//  Created by Ellen Shapiro (Vokal) on 9/24/15.
//  Copyright © 2015 Vokal. All rights reserved.
//

import Foundation
import SpriteKit

enum TurnDirection {
    case Left,
    Right,
    Up,
    Down
}

class Snake {
    
    let head = SnakeHeadNode()
    var bodyPartCount = 3 //Start with this many body parts.
    var currentDirection: TurnDirection?
    
    //MARK:- User navigation of the snake
    
    func turn(direction: TurnDirection) {
        self.currentDirection = direction
    }
    
    //MARK:- Food Consumption
    
    func eatFood() {
        //Add a body part to the end of the snake. 
        ++self.bodyPartCount
    }
}