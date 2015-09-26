//
//  Grid.swift
//  SwiftSnake
//
//  Created by Ellen Shapiro (Vokal) on 9/25/15.
//  Copyright © 2015 Vokal. All rights reserved.
//

import UIKit

struct Grid {
    //Since TVs are 16x9...
    static let multiplier = 2
    static let columns = 16 * multiplier
    static let rows = 9 * multiplier
    
    private var size: CGSize
    
    var backingStore: GridStorage<PieceToDisplay> = GridStorage(columns: Grid.columns,
        rows: Grid.rows)
    var centerStore: GridStorage<CGPoint> = GridStorage(columns: Grid.columns,
        rows: Grid.rows)
    
    init(size: CGSize) {
        self.size = size
    }
    
    //MARK: - Size Helpers
    func itemWidth() -> CGFloat {
        return self.size.width / CGFloat(Grid.columns)
    }
    
    func itemHeight() -> CGFloat {
        return self.size.height / CGFloat(Grid.rows)
    }
    
    //MARK: Setup
    
    func setupGrid(perItemBlock: (Int, Int) -> ()) {
        for column in 0..<Grid.columns {
            for row in 0..<Grid.rows {
                perItemBlock(column, row)
            }
        }
    }
}