//
//  GridBackgroundNode.swift
//  SwiftSnake
//
//  Created by Ellen Shapiro (Vokal) on 9/24/15.
//  Copyright © 2015 Vokal. All rights reserved.
//

import Foundation
import SpriteKit

class GridBackgroundNode: SKNode {
    
    //Since TVs are 16x9...
    private static let multiplier = 2
    private static let columns = 16 * multiplier
    private static let rows = 9 * multiplier
    
    var backingStore: GridStorage<PieceToDisplay> = GridStorage(columns: GridBackgroundNode.columns,
        rows: GridBackgroundNode.rows)
    var centerStore: GridStorage<CGPoint> = GridStorage(columns: GridBackgroundNode.columns,
    rows: GridBackgroundNode.rows)
    
    //MARK: - Init
    
    private func commonPostInit() {
        self.name = NodeName.Background.rawValue
    }
    
    override init() {
        super.init()
        commonPostInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        assertionFailure("Don't use a coder, use init!")
        
        /*
            I would return nil here, but the compiler whines when I do:
            "All stored properties of a class instance must be initialized
            before returning nil from an initializer" - Wait, what? OK, 
            fine, be that way. I'll just return the damned object then.
        */
        super.init(coder: aDecoder)
        commonPostInit()
    }
    
    //MARK: - Setup
    
    func itemWidth(gridSize: CGSize) -> CGFloat {
        return gridSize.width / CGFloat(GridBackgroundNode.columns)
    }
    
    func itemHeight(gridSize: CGSize) -> CGFloat {
        return gridSize.height / CGFloat(GridBackgroundNode.rows)
    }
    
    func setupGrid(gridSize: CGSize) {
        let xWidth = itemWidth(gridSize)
        let yHeight = itemHeight(gridSize)
        let nodeSize = CGSize(width: xWidth, height: yHeight)
        
        for column in 0..<GridBackgroundNode.columns {
            let xOrigin = xWidth * CGFloat(column) + xWidth / 2
            for row in 0..<GridBackgroundNode.rows {
                let yOrigin = yHeight * CGFloat(row) + yHeight / 2
                let space = SpaceNode.emptyNodeOfSize(nodeSize)
                space.position = CGPointMake(xOrigin, yOrigin)
                
                let center = CGPoint(x: CGRectGetMidX(space.frame),
                    y: CGRectGetMidY(space.frame))
                centerStore[column, row] = center
                self.addChild(space)
            }
        }
    }
    
    func addSnake(snake: Snake) {
        //TODO: Actually add snake
        
        let middleRow = GridBackgroundNode.rows / 2
        let middleColumn = GridBackgroundNode.columns / 2
        
        backingStore[middleColumn, middleRow] = .SnakeHead
        backingStore[middleColumn + 1, middleRow] = .SnakeBody
        backingStore[middleColumn + 2, middleRow] = .SnakeBody
    }
    
    
    //MARK: Display logic
    
    
    func updateDisplayFromBackingStore(snake: Snake, size: CGSize) {
        self.removeAllChildren()
        for column in 0..<GridBackgroundNode.columns {
            for row in 0..<GridBackgroundNode.rows {
                if let piece = backingStore[column, row],
                    let center = centerStore[column, row] {
                        var node: SKNode
                        switch piece {
                        case .SnakeHead:
                            node = SnakeHeadNode.withDirection(snake.currentDirection)
                        case .SnakeBody:
                            node = SnakeBodyPartNode.withPart(.Horizontal)
                        case .Food:
                            node = FoodNode.makeFood()
                        }
                        
                        self.addChild(node)
                        
                        node.xScale = itemWidth(size) / CGRectGetWidth(node.frame)
                        node.yScale = itemHeight(size) / CGRectGetHeight(node.frame)
                        node.position = center
                }
            }
        }
    }    
    
    //MARK: - Other Scenes
    
    func showGameOver() {
        //TODO: Show game over scene
        print("GAME OVER")
    }
}

//MARK: - SKPhysicsContactDelegate

extension GridBackgroundNode: SKPhysicsContactDelegate {
    func didBeginContact(contact: SKPhysicsContact) {
//        guard let firstNode = contact.bodyA.node as? SKSpriteNode,
//        let secondNode = contact.bodyB.node as? SKSpriteNode else {
//            assertionFailure("THESE AIN'T NO NODES");
//            return
//        }
        
        if CollisionHandler.isOuroboros(contact.bodyA, contact.bodyB) {
            showGameOver()
        } else if CollisionHandler.isEating(contact.bodyA, contact.bodyB) {
            //TODO: Make snake longer
            print("OM NOM NOM");
        }
    }
}
