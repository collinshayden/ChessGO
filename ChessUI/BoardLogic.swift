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
    var firstClickedSquare: Square?
    var secondClickedSquare: Square?
    var legalMoves: [Square]
    
    init(puzzle: Puzzle) {
        boardState = Board(position: Position(fen: puzzle.fen)!)
        legalMoves = []
    }
    
    func click(pos: String) {
        // if first click is nil, calc legal moves
        if firstClickedSquare == nil {
            firstClickedSquare = Square(pos)
            legalMoves = boardState.legalMoves(forPieceAt: firstClickedSquare!)
            print("First square clicked at \(pos)")
        }
        // else if first square has already been clicked, check if new click is legal
        else {
            secondClickedSquare = Square(pos)
            if checkLegalMove(pos: pos) {
                print("move from \(firstClickedSquare!.notation) to \(pos) is legal")
            }
            // if second click wasn't in legal moves, reset and calculate legal moves for the new square
            else {
                firstClickedSquare = secondClickedSquare
                secondClickedSquare = nil
                legalMoves = boardState.legalMoves(forPieceAt: firstClickedSquare!)
            }

        }
    }
    
    func getLegalMoves() -> [Square] {
        return legalMoves
    }
    
    func checkLegalMove(pos: String) -> Bool {
        if legalMoves.contains(where: {$0.notation == pos}) {
            return true
        }
        else {
            return false
        }
        
    }
}
