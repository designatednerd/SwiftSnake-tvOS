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
        scene.backgroundColor = .blackColor()
        
        scene.backgroundNode = GridBackgroundNode()
        scene.backgroundNode.setupGrid(sceneSize)
        scene.addChild(scene.backgroundNode)
        
        scene.snake = Snake()
        scene.backgroundNode.addSnake(scene.snake)
        
        scene.physicsWorld.contactDelegate = scene.backgroundNode
        return scene
    }
    
    func addRemoteHandlingToView(view: UIView) {
        let panRecognizer = UIPanGestureRecognizer()
        panRecognizer.addTarget(self, action: "handlePan:")
        view.addGestureRecognizer(panRecognizer)
    }
    
    func handlePan(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .Began:
            self.touchBegin = recognizer.locationInView(self.view)
        case .Changed:
            let currentTouch = recognizer.locationInView(self.view)
            let deltaX = self.touchBegin.x - currentTouch.x
            let deltaY = self.touchBegin.y - currentTouch.y
            
            if abs(deltaX) > abs(deltaY) {
                //More horizontal than vertical.
                if deltaX > 0 {
                    print("LEFT")
                    snake?.turn(.Left)
                } else {
                    print("RIGHT")
                    snake?.turn(.Right)
                }
            } else {
                //More vertical than horizontal. 
                if deltaY > 0 {
                    print("UP")
                    snake?.turn(.Up)
                } else {
                    print("DOWN")
                    snake?.turn(.Down)
                }
            }
            
        case .Cancelled:
                fallthrough
        case .Ended:
            //Reset begin point
            self.touchBegin = CGPointZero
        default:
            //Do nada
            break
            
        }
    }
    
    override func update(currentTime: NSTimeInterval) {
        backgroundNode.updateDisplayFromBackingStore(snake, size: self.view!.frame.size)
    }
}