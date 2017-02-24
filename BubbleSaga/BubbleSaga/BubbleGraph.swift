//
//  Graph.swift
//  GameEngine
//
//  Created by dinhvt on 12/2/17.
//  Copyright © 2017 nus.cs3217.a0126513. All rights reserved.
//

import PhysicsEngine

class BubbleGraph {
    
    private var numRow: Int
    private var numCol: Int
    private var nodeList: [Index: Node]
    private var adjacentList: [Index: [Index]]
    
    init(numRow: Int, numCol: Int) {
        self.numRow = numRow
        self.numCol = numCol
        nodeList = [Index: Node]()
        adjacentList = [Index: [Index]]()
        buildGraph()
    }
    
    private func buildGraph() {
        for row in 0..<numRow {
            for col in 0..<numColumnsOfRow(row) {
                let index = Index(row: row, col: col)
                nodeList[index] = Node(index: index)
                adjacentList[index] = getAdjacentNodesOfNodeAt(index: index)
            }
        }
    }
    
    private func getAdjacentNodesOfNodeAt(index: Index) -> [Index] {
        let row = index.row
        let col = index.col
        var result = [Index]()
        
        addToResult(&result, tmpRow: row, tmpCol1: col - 1, tmpCol2: col + 1)
        
        var tmpCol1: Int
        var tmpCol2: Int
        if row % 2 == 0 {
            tmpCol1 = col - 1
            tmpCol2 = col
        } else {
            tmpCol1 = col
            tmpCol2 = col + 1
        }
        
        addToResult(&result, tmpRow: row - 1, tmpCol1: tmpCol1, tmpCol2: tmpCol2)
        addToResult(&result, tmpRow: row + 1, tmpCol1: tmpCol1, tmpCol2: tmpCol2)
        
        return result
    }
    
    private func numColumnsOfRow(_ row: Int) -> Int {
        if row % 2 == 0 {
            return numCol
        }
        return numCol - 1
    }
    
    // Add (tmpRow, tmpCol1) and (tmpRow, tmpCol2) to result
    private func addToResult(_ result: inout [Index], tmpRow: Int, tmpCol1: Int, tmpCol2: Int) {
        if tmpRow < 0 || tmpRow > numRow - 1 {
            return
        }
        if tmpCol1 >= 0 && tmpCol1 < numColumnsOfRow(tmpRow) {
            result.append(Index(row: tmpRow, col: tmpCol1))
        }
        if tmpCol2 >= 0 && tmpCol2 < numColumnsOfRow(tmpRow) {
            result.append(Index(row: tmpRow, col: tmpCol2))
        }
    }
    
    func changeBubbleTypeAt(row: Int, col: Int, type: BubbleType) {
        nodeList[Index(row: row, col: col)]?.type = type
    }
    
    func clearBubbleAt(row: Int, col: Int) {
        nodeList[Index(row: row, col: col)]?.type = .empty
    }
    
    // Run bfs to find connected component of the same color
    // Delete all bubble in the connected component if
    // the connected component size if >= Constant.GROUP_SIZE_TO_EXPLODE
    func getAndDeleteConnectedComponentOfTheSameColorAt(row: Int, col: Int) -> [Index] {
        var connectedComponent = [Index]()
        var queue = Queue<Index>()
        var visited = Set<Index>()
        
        let rootIndex = Index(row: row, col: col)
        let type = nodeList[rootIndex]?.type
        visited.insert(rootIndex)
        queue.enqueue(rootIndex)
        
        while !queue.isEmpty {
            let currentIndex = try! queue.dequeue()
            connectedComponent.append(currentIndex)
            let neighbors = getAdjacentNodesOfNodeAt(index: currentIndex)
            for neighbor in neighbors {
                if visited.contains(neighbor) {
                    continue
                }
                
                if nodeList[neighbor]?.type != type {
                    continue
                }
                visited.insert(neighbor)
                queue.enqueue(neighbor)
            }
        }
        
        if connectedComponent.count < Constant.GROUP_SIZE_TO_EXPLODE {
            return connectedComponent
        }
        
        for index in connectedComponent {
            clearBubbleAt(row: index.row, col: index.col)
        }
        
        return connectedComponent
    }
    
    // Run bfs to find and delete all mid air bubble
    func getAndDemoveMidAirBubbles() -> [Index] {
        var connectedComponent = [Index]()
        var queue = Queue<Index>()
        var visited = Set<Index>()
        
        for col in 0..<numCol {
            let index = Index(row: 0, col: col)
            let type = nodeList[index]?.type
            if type != .empty {
                visited.insert(index)
                queue.enqueue(index)
            }
        }
        
        while !queue.isEmpty {
            let currentIndex = try! queue.dequeue()
            connectedComponent.append(currentIndex)
            let neighbors = getAdjacentNodesOfNodeAt(index: currentIndex)
            for neighbor in neighbors {
                if visited.contains(neighbor) {
                    continue
                }
                if nodeList[neighbor]?.type == .empty {
                    continue
                }
                visited.insert(neighbor)
                queue.enqueue(neighbor)
            }
        }
        
        var result = [Index]()
        for neighbor in nodeList.keys {
            if !visited.contains(neighbor) && nodeList[neighbor]?.type != .empty {
                result.append(neighbor)
                clearBubbleAt(row: neighbor.row, col: neighbor.col)
            }
        }
        
        return result
    }
    
}

struct Node {
    var index: Index
    var type: BubbleType
    
    init(index: Index) {
        self.index = index
        type = .empty
    }
}
