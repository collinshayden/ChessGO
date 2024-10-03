//
//  ChessLogic.swift
//  ChessUI
//
//  Created by James Birmingham on 10/3/24.
//

import Foundation
import SwiftUI
import ChessKit

struct piece {
    var id: Character?
    var icon: Image?
}

struct move {
    var start_row: Int
    var start_col: Int
    var target_row: Int
    var target_col: Int
}

func parsePuzzle(puzzle: String) -> ([[piece]], [move], Bool) {
    var pieces: [[piece]] = [[],[],[],[],[],[],[],[]]
    var moves: [move] = []
    var orientation = true
    return (pieces, moves, orientation)
}

func parseSolution(moves: String) -> [[Square]] {
    var squareLists: [[Square]] = []
    var splitMoves = moves.split(separator: " ")
    
    for move in splitMoves {
        var source = Square(String(move.prefix(2)))
        var destination = Square(String(move.suffix(2)))
        squareLists.append([source, destination])
    }
        
    return squareLists
}


func parseFEN(fen: String) -> [[piece]] {
    // piece id to icon dictionary
    let pieceImages: Dictionary<Character, Image> = [
        "p": Image(.chessPdt45Svg),
        "r": Image(.chessRdt45Svg),
        "n": Image(.chessNdt45Svg),
        "b": Image(.chessBdt45Svg),
        "q": Image(.chessQdt45Svg),
        "k": Image(.chessKdt45Svg),
        "P": Image(.chessPlt45Svg),
        "R": Image(.chessRlt45Svg),
        "N": Image(.chessNlt45Svg),
        "B": Image(.chessBlt45Svg),
        "Q": Image(.chessQlt45Svg),
        "K": Image(.chessKlt45Svg)
    ]
    
    // array of arrays which holds pieces [row][col]
    var pieces: [[piece]] = [[],[],[],[],[],[],[],[]]
    
    // tracks location of each piece in FEN
    var row = 0
    
    for char in fen {
        // checks if the row has ended
        if char == "/" {
            row += 1
        // checks if there isn't a piece at a position
        } else if char.isNumber {
            let n = Int(String(char))
            for _ in 0..<n! {
                pieces[row].append(piece())
            }
        // checks if all pieces have been read
        } else if char == " " {
            break
        // adds a piece
        } else {
            pieces[row].append(piece(
                id: char,
                icon: pieceImages[char]))
        }
    }
    return pieces
}
