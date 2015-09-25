//
//  SnakeGameScene.swift
//  SwiftSnake
//
//  Created by Ellen Shapiro (Vokal) on 9/24/15.
//  Copyright © 2015 Vokal. All rights reserved.
//

import Foundation
import SpriteKit

class SnakeGameScene: SKScene {
    
    var touchBegin = CGPointZero
    var snake: Snake!
    var backgroundNode: GridBackgroundNode!
    
    /**
     Factory method.
     
     - parameter sceneSize: The CGSize of the scene.
     
     - returns: The created scene. 
     */
    static func makeSceneOfSize(sceneSize: CGSize) -> SnakeGameScene {
        let scene = SnakeGameScene(size: sceneSize)
        scene.backgroundColor = .redColor()
        
        scene.backgroundNode = GridBackgroundNode()
        scene.backgroundNode.setupGrid(sceneSize)
        scene.addChild(scene.backgroundNode)
        
        scene.snake = Snake()
        scene.backgroundNode.addSnake(scene.snake)
        
        scene.physicsWorld.contactDelegate = scene.backgroundNode
        return scene
    }
    override func update(currentTime: NSTimeInterval) {
        backgroundNode.updateDisplayFromBackingStore(snake, size: self.view!.frame.size)
    }
}