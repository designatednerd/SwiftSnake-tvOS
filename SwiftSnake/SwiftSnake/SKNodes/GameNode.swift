//
//  GameNode.swift
//  SwiftSnake
//
//  Created by Ellen Shapiro (Vokal) on 9/25/15.
//  Copyright © 2015 Vokal. All rights reserved.
//

import Foundation
import SpriteKit

class GameNode: SKNode {
    
    var grid: Grid
    let snake: Snake
    var timer: NSTimer?
    var snakeHeadColumnAndRow: (Int, Int) = (0,0)
    var directionWhenEndAdded: TurnDirection = .Left
    var snakeEndColumnAndRow: (Int, Int) = (0,0)
    var foodsEaten = 0
    
    //MARK: - Init
    
    init(grid: Grid, snake: Snake) {
        self.snake = snake
        self.grid = grid
        super.init()
        
        addSnake()
        addFood()
    }
    
    required init?(coder aDecoder: NSCoder) {
        assertionFailure("You should use the main initializer")
        self.grid = Grid(size: CGSizeZero)
        self.snake = Snake()
        super.init(coder: aDecoder)
    }
    
    
    //MARK: - Setup
    
    func addFood() {
        let tenPercent = Grid.columns * Grid.rows / 10
        for _ in 0...tenPercent {
            let randomColumn = Randomizer.randomIntWithSeed(Grid.columns)
            let randomRow = Randomizer.randomIntWithSeed(Grid.rows)
            if self.grid.backingStore[randomColumn, randomRow] == nil {
                self.grid.backingStore[randomColumn, randomRow] = .Food
            }
        }
    }
    
    func addSnake() {
        let middleRow = Grid.rows / 2
        let middleColumn = Grid.columns / 2
        
        self.grid.backingStore[middleColumn, middleRow] = .SnakeHead
        self.snakeHeadColumnAndRow = (middleColumn, middleRow)
        
        for bodyPart in 1...self.snake.bodyPartCount {
            let column = middleColumn + bodyPart
            self.grid.backingStore[column, middleRow] = .SnakeBody
            if bodyPart == self.snake.bodyPartCount {
                self.snakeEndColumnAndRow = (column, middleRow)
            }
        }
    }
    
    func startTimer() {
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1,
            target: self,
            selector: "moveSnakeInBackingStore",
            userInfo: nil,
            repeats: true)
    }

    //MARK: - Display logic
    
    func moveSnakeInBackingStore() {
        //Move the head of the snake
        var headX = self.snakeHeadColumnAndRow.0
        var headY = self.snakeHeadColumnAndRow.1
        
        //The head will be replaced by the body
        self.grid.backingStore[headX, headY] = .SnakeBody
        
        switch snake.currentDirection {
        case .Up:
            ++headY
        case .Down:
            --headY
        case .Left:
            --headX
        case .Right:
            ++headX
        }
        
        if headX < 0
            || headX >= (Grid.columns - 1)
            || headY < 0
            || headY >= (Grid.rows - 1) {
                
            // You're off the board. FAIL.
            self.showGameOver()
            return;
        }
        
        self.snakeHeadColumnAndRow = (headX, headY)
        self.grid.backingStore[headX, headY] = .SnakeHead
        
        //Move the end of the snake
        var endX = self.snakeEndColumnAndRow.0
        var endY = self.snakeEndColumnAndRow.1
        
        //The end will be replaced by nothing
        self.grid.backingStore[endX, endY] = nil

        switch directionWhenEndAdded {
        case .Up:
            ++endY
        case .Down:
            --endY
        case .Left:
            --endX
        case .Right:
            ++endX
        }
        
        self.snakeEndColumnAndRow = (endX, endY)
    }
  
    func updateDisplayFromBackingStore() {
        self.removeAllChildren()
        self.grid.setupGrid {
            column, row in
            if let piece = self.grid.backingStore[column, row],
                let center = self.grid.centerStore[column, row] {
                    var node: SKNode
                    switch piece {
                    case .SnakeHead:
                        node = SnakeHeadNode.withDirection(self.snake.currentDirection)
                    case .SnakeBody:
                        node = SnakeBodyPartNode.withPart(.Horizontal)
                    case .Food:
                        node = FoodNode.makeFood()
                    }
                    
                    self.addChild(node)
                    
                    node.xScale = self.grid.itemWidth() / CGRectGetWidth(node.frame)
                    node.yScale = self.grid.itemHeight() / CGRectGetHeight(node.frame)
                    node.position = center
            }
        }
    }
    
    //MARK: - Food Eating
    
    
    //MARK: - Other Scenes
    
    func showGameOver() {
        self.timer?.invalidate()
        
        //TODO: Show game over scene
        print("GAME OVER")
    }
}

//MARK: - SKPhysicsContactDelegate

extension GameNode: SKPhysicsContactDelegate {
    
    func didBeginContact(contact: SKPhysicsContact) {
        if CollisionHandler.isOuroboros(contact.bodyA, contact.bodyB) {
            showGameOver()
        } else if CollisionHandler.isEating(contact.bodyA, contact.bodyB) {
            //TODO: Make snake longer
            print("OM NOM NOM");
        }
    }
}
