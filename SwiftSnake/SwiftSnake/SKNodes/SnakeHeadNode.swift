//
//  SnakeHead.swift
//  SwiftSnake
//
//  Created by Ellen Shapiro (Vokal) on 9/24/15.
//  Copyright © 2015 Vokal. All rights reserved.
//

import Foundation
import SpriteKit

enum SnakeHeadDirection: String {
    case Up = "SnakeHeadUp",
    Down = "SnakeHeadDown",
    Right = "SnakeHeadRight",
    Left = "SnakeHeadLeft"
    
    static func fromTurnDirection(turnDirection: TurnDirection?) -> SnakeHeadDirection {
        guard let direction = turnDirection else {
            return .Left
        }
        
        switch direction {
        case .Up:
            return .Up
        case .Down:
            return .Down
        case .Right:
            return .Right
        case .Left:
            return .Left
        }
    }
}

class SnakeHeadNode: SKSpriteNode {
    
    //MARK:- Factory
    
    static func withDirection(direction: TurnDirection?) -> SnakeHeadNode {
        let headDirection = SnakeHeadDirection.fromTurnDirection(direction)
        let node = SnakeHeadNode(imageNamed:headDirection.rawValue)
        node.name = NodeName.SnakeHead.rawValue
        node.physicsBody?.categoryBitMask = NodeBitmask.SnakeHead.rawValue
        return node        
    }

}
