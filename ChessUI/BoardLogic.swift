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
            print("d4 found")
        }
    }
    
    func getLegalMoves() -> [Square] {
        return legalMoves
    }
    
    func checkLegalMove(pos: String) -> Bool {
        return legalMoves.contains {$0.notation == pos}
    }
}
