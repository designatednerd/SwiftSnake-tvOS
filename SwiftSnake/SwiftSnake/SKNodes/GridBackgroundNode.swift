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
    
    var grid: Grid

    //MARK: - Init
    
    init(grid: Grid) {
        self.grid = grid
        super.init()
        self.name = NodeName.Background.rawValue
        self.setupBackground()
    }
    
    required init?(coder aDecoder: NSCoder) {
        assertionFailure("Don't use a coder, use init!")
        
        /*
            I would return nil here, but the compiler whines when I do:
            "All stored properties of a class instance must be initialized
            before returning nil from an initializer" - Wait, what? OK, 
            fine, be that way. I'll just return the damned object then.
        */
        self.grid = Grid(size: CGSizeZero)
        super.init(coder: aDecoder)
    }
    
    //MARK: - Setup
    
    func setupBackground() {
        let xWidth = self.grid.itemWidth()
        let yHeight = self.grid.itemHeight()
        let nodeSize = CGSize(width: xWidth, height: yHeight)

        self.grid.setupGrid {
            column, row in        
            let xOrigin = xWidth * CGFloat(column) + xWidth / 2
            let yOrigin = yHeight * CGFloat(row) + yHeight / 2
            let space = SpaceNode.emptyNodeOfSize(nodeSize)
            space.position = CGPointMake(xOrigin, yOrigin)
            let center = CGPoint(x: CGRectGetMidX(space.frame), y: CGRectGetMidY(space.frame))
            self.grid.centerStore[column, row] = center
            self.addChild(space)
        }
    }
}


