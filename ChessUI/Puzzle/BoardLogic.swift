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
    var puzzleFailed = false
    var promoting = false
    var mv: ChessKit.Move?
    
    init(selectedPuzzle: Puzzle) {
        puzzle = selectedPuzzle
        boardState = Board(position: Position(fen: puzzle.fen)!)
        legalMoves = []
        // take computer's first move
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
            withAnimation(.easeInOut(duration: 0.5)) {
                let cMv = boardState.move(pieceAt: puzzle.moves[0].source, to: puzzle.moves[0].destination)
                if puzzle.moves[0].promotion != nil {
                    boardState.completePromotion(of: cMv!, to: Constants.idKinds[puzzle.moves[0].promotion!]!)
                }
                lastMoveCoords = [puzzle.moves[0].source.notation, puzzle.moves[0].destination.notation]
            }
        }
    }
    
    // resets all the board vars to restart the puzzle
    func reset() {
        legalMoves = []
        firstClickedSquare = nil
        secondClickedSquare = nil
        moveNum = 1 // set to 1 because the computer is the first move which will be taken now
        msg = "Resetting the board"
        puzzleComplete = false
        puzzleFailed = false
        // take computer's first move
        boardState = Board(position: Position(fen: puzzle.fen)!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
            withAnimation(.easeInOut(duration: 0.5)) {
                let cMv = boardState.move(pieceAt: puzzle.moves[0].source, to: puzzle.moves[0].destination)
                if puzzle.moves[0].promotion != nil {
                    boardState.completePromotion(of: cMv!, to: Constants.idKinds[puzzle.moves[moveNum].promotion!]!)
                }
                lastMoveCoords = [puzzle.moves[0].source.notation, puzzle.moves[0].destination.notation]
            }
        }
    }
    
    func click(pos: String) {
        // if the clicked piece is the user's color, select it as move origin
        if boardState.position.sideToMove == boardState.position.piece(at: Square(pos))?.color {
            firstClickedSquare = Square(pos)
            legalMoves = boardState.legalMoves(forPieceAt: firstClickedSquare!)
        } else {
            //dont do anything if it isn't legal
            if !checkLegalMove(pos: pos) {
                firstClickedSquare = nil
                legalMoves = []
                return
            }
            
            secondClickedSquare = Square(pos)
            
            
            // move user's piece
            mv = boardState.move(pieceAt: firstClickedSquare!, to: secondClickedSquare!)!
            lastMoveCoords = [firstClickedSquare!.notation, secondClickedSquare!.notation]
            
            // check if the piece needs to be promoted
            if (mv!.end.rank == 1 || mv!.end.rank == 8) && mv!.piece.kind == .pawn {
                withAnimation(.easeIn) {
                    promoting = true
                }
                return
            }
            
            // check if the move was correct
            if puzzle.moves[moveNum] == Move(source: firstClickedSquare!, destination: secondClickedSquare!) {
                msg = "Correct! Keep going!"
                moveNum += 1
                // check if the user completed the puzzle
                if moveNum == puzzle.moves.count {
                    msg = "Puzzle Complete!"
                    puzzleComplete = true
                    return
                }
            // set puzzle failed flag if the move wasn't correct and show constructive criticism
            } else {
                msg = "You disgust me. Hint: \(puzzle.moves[moveNum].source.notation)"
                legalMoves = []
                puzzleFailed = true
                return
            }
            // move computer's piece
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
                withAnimation(.easeInOut(duration: 0.5)) {
                    let cMv = boardState.move(pieceAt: puzzle.moves[moveNum].source, to: puzzle.moves[moveNum].destination)
                    if puzzle.moves[moveNum].promotion != nil {
                        boardState.completePromotion(of: cMv!, to: Constants.idKinds[puzzle.moves[moveNum].promotion!]!)
                    }
                    lastMoveCoords = [puzzle.moves[moveNum].source.notation, puzzle.moves[moveNum].destination.notation]
                }
                moveNum += 1
            }
            // after the move is made, reset the origin/target and legal moves
            firstClickedSquare = nil
            secondClickedSquare = nil
            legalMoves = []
        }
        return
    }
    
    func promotePiece(piece: Piece.Kind) {
        boardState.completePromotion(of: mv!, to: piece)
        
        // check if the move was correct
        if puzzle.moves[moveNum] == Move(source: firstClickedSquare!, destination: secondClickedSquare!, promotion: Constants.kindsId[piece]) {
            msg = "Correct! Keep going!"
            moveNum += 1
            // check if the user completed the puzzle
            if moveNum == puzzle.moves.count {
                msg = "Puzzle Complete!"
                puzzleComplete = true
                return
            }
        // set puzzle failed flag if the move wasn't correct and show constructive criticism
        } else {
            msg = "You disgust me. Hint: \(puzzle.moves[moveNum].source.notation)"
            legalMoves = []
            puzzleFailed = true
            return
        }
        
        // move computer's piece
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
            withAnimation(.easeInOut(duration: 0.5)) {
                let cMv = boardState.move(pieceAt: puzzle.moves[moveNum].source, to: puzzle.moves[moveNum].destination)
                if puzzle.moves[moveNum].promotion != nil {
                    boardState.completePromotion(of: cMv!, to: Constants.idKinds[puzzle.moves[moveNum].promotion!]!)
                }
                lastMoveCoords = [puzzle.moves[moveNum].source.notation, puzzle.moves[moveNum].destination.notation]
            }
            moveNum += 1
        }
        
        // after the move is made, reset the origin/target and legal moves
        firstClickedSquare = nil
        secondClickedSquare = nil
        legalMoves = []
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
    
    func getPieces() -> [[Character]] {
        return parseFEN(self.boardState.position.fen)
    }
    
    func getHintSquares() -> [String] {
        return !puzzleComplete ? [self.puzzle.moves[self.moveNum].source.notation, self.puzzle.moves[self.moveNum].destination.notation] : []
    }
}



