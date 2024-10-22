//
//  BoardLogic.swift
//  ChessUI
//
//  Created by James Birmingham on 10/8/24.
//

import Foundation
import ChessKit
import SwiftUI

class BoardLogic : ObservableObject {
    @Published var boardState: Board
    @Published var legalMoves: [Square]
    @Published var lastMoveCoords: [String]?
    var puzzle: Puzzle
    var firstClickedSquare: Square?
    var secondClickedSquare: Square?
    var moveNum: Int = 1
    var msg: String = ""
    var puzzleComplete = false
    
    
    init(selectedPuzzle: [String]) {
        puzzle = parsePuzzle(selectedPuzzle: selectedPuzzle)
        boardState = Board(position: Position(fen: puzzle.fen)!)
        legalMoves = []
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
            withAnimation(.easeInOut(duration: 0.5)) {
                _ = boardState.move(pieceAt: puzzle.moves[0].source, to: puzzle.moves[0].destination)
                self.lastMoveCoords = [puzzle.moves[0].source.notation, puzzle.moves[0].destination.notation]
            }
        }
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
                    self.lastMoveCoords = [firstClickedSquare!.notation, secondClickedSquare!.notation]
                    msg = "Correct! Keep going!"
                    moveNum += 1
                    if moveNum < puzzle.moves.count {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
                            withAnimation(.easeInOut(duration: 0.5)) {
                                self.boardState.move(pieceAt: puzzle.moves[moveNum].source, to: puzzle.moves[moveNum].destination)
                                self.lastMoveCoords = [puzzle.moves[moveNum].source.notation, puzzle.moves[moveNum].destination.notation]
                            }
                            moveNum += 1
                        }
                    }
                    else {
                        msg = "Puzzle Complete!"
                        puzzleComplete = true
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
    
    func getHintSquares() -> [String] {
        return !puzzleComplete ? [self.puzzle.moves[self.moveNum].source.notation, self.puzzle.moves[self.moveNum].destination.notation] : []
    }
}



