//
//  BoardLogic.swift
//  ChessUI
//
//  Created by James Birmingham on 10/8/24.
//

import Foundation
import ChessKit

class BoardLogic : ObservableObject {
    @Published var boardState: Board
    @Published var legalMoves: [Square]
    var puzzle: Puzzle
    var firstClickedSquare: Square?
    var secondClickedSquare: Square?
    var moveNum: Int = 1
    var msg: String = ""
    
    init(selectedPuzzle: [String]) {
        puzzle = parsePuzzle(selectedPuzzle: selectedPuzzle)
        boardState = Board(position: Position(fen: puzzle.fen)!)
        legalMoves = []
        boardState.move(pieceAt: puzzle.moves[0].source, to: puzzle.moves[0].destination)
    }
    
    func click(pos: String) {
        // if first click is nil, calc legal moves
        if firstClickedSquare == nil {
            firstClickedSquare = Square(pos)
            
            if boardState.position.sideToMove == boardState.position.piece(at: firstClickedSquare!)?.color {
                legalMoves = boardState.legalMoves(forPieceAt: firstClickedSquare!)
            }
        }
        // else if first square has already been clicked, check if new click is legal
        else {
            secondClickedSquare = Square(pos)
            if checkLegalMove(pos: pos) {
                if puzzle.moves[moveNum] == Move(source: firstClickedSquare!, destination: secondClickedSquare!) {
                    boardState.move(pieceAt: firstClickedSquare!, to: secondClickedSquare!)
                    msg = "Correct! Keep going!"
                    moveNum += 1
                    if moveNum < puzzle.moves.count {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
                            self.boardState.move(pieceAt: puzzle.moves[moveNum].source, to: puzzle.moves[moveNum].destination)
                            moveNum += 1
                        }
                    }
                    else {
                        msg = "Puzzle Complete!"
                    }
                }
                else {
                    msg = "Not quite. Hint: \(puzzle.moves[moveNum].source.notation)"
                }
                
                legalMoves = []
            }
            // if second click wasn't in legal moves, reset and calculate legal moves for the new square
            else {
                firstClickedSquare = secondClickedSquare
                secondClickedSquare = nil
                if boardState.position.sideToMove == boardState.position.piece(at: firstClickedSquare!)?.color {
                    legalMoves = boardState.legalMoves(forPieceAt: firstClickedSquare!)
                }
            }
            
        }
    }
    
    func getLegalMoves() -> [Square] {
        return legalMoves
    }
    
    func checkLegalMove(pos: String) -> Bool {
        return legalMoves.contains(where: {$0.notation == pos})
    }
    
    func getPuzzle() -> Puzzle {
        return puzzle
    }
    
    func getPieces() -> [[Piece]] {
        return parseFEN(fen: self.boardState.position.fen)
    }
}



