//
//  SpaceNode.swift
//  SwiftSnake
//
//  Created by Ellen Shapiro (Vokal) on 9/24/15.
//  Copyright © 2015 Vokal. All rights reserved.
//

import Foundation
import SpriteKit

class SpaceNode: SKShapeNode {
    
    static func emptyNodeOfSize(nodeSize: CGSize) -> SpaceNode {
        let node = SpaceNode(rectOfSize: nodeSize)
        node.fillColor = .blackColor()
        node.strokeColor = .whiteColor()
        node.lineWidth = 1
        node.name = NodeType.Space.rawValue
        
        node.addFood(FoodNode.makeFood())
        return node;
    }
    
    func addFood(food: FoodNode) {
        food.position = CGPointMake(0, 0)
        self.addChild(food)
    }
}