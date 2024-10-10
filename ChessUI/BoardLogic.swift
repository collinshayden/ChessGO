//
//  BoardLogic.swift
//  ChessUI
//
//  Created by James Birmingham on 10/8/24.
//

import Foundation
import ChessKit

class BoardLogic {
    var boardState: Board
    var clickedSquare: Square?
    var legalMoves: [Square]
    
    init(puzzle: Puzzle) {
        boardState = Board(position: Position(fen: puzzle.fen)!)
        legalMoves = []
    }
    
    func click(pos: String) {
        clickedSquare = Square(pos)
        legalMoves = boardState.legalMoves(forPieceAt: clickedSquare!)
        
        if (legalMoves.contains {$0.notation == "d4"}) {
                    print("d4 found from click function, pos \(pos)")
                }
    }
    
    func getLegalMoves() -> [Square] {
        return legalMoves
    }
    
    func checkLegalMove(pos: String) -> Bool {
        if legalMoves.contains(where: {$0.notation == pos}) {
            print(" LEFLELFE \(pos)")
            return true
        }
        else {
            return false
        }
        
    }
    
    func consolePrint() {
        print("AWHDNJAWD")
    }
}
