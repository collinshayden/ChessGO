//
//  BoardLogic.swift
//  ChessUI
//
//  Created by James Birmingham on 10/8/24.
//

import Foundation
import ChessKit

class BoardLogic: ObservableObject {
    var puzzle: Puzzle
    @Published var boardState: Board
    var clickedSquare: Square?
    @Published var legalMoves: [Square]
    
    init(selectedPuzzle: [String]) {
        puzzle = parsePuzzle(selectedPuzzle: selectedPuzzle)
        boardState = Board(position: Position(fen: puzzle.fen)!)
        legalMoves = []
    }
    
    func click(pos: String) {
        clickedSquare = Square(pos)
        legalMoves = boardState.legalMoves(forPieceAt: clickedSquare!)
        print("Length of legal moves after assignment: " + String(legalMoves.count))
        //print(legalMoves[0].notation)
        //if checkLegalMove(pos: "d4") {
        //    print("d4 found")
        //}
    }
    
    func getLegalMoves() -> [Square] {
        return legalMoves
    }
    
    func checkLegalMove(pos: String) -> Bool {
        //print("Length of legal moves when checking: " + String(legalMoves.count))
        return legalMoves.contains {$0.notation == pos}
    }
    
    func getPuzzle() -> Puzzle {
        return puzzle
    }
    
    func move(pos: String) -> Bool {
        boardState.canMove(pieceAt: clickedSquare!, to: Square(pos))
    }
}
