//
//  ChessLogic.swift
//  ChessUI
//
//  Created by James Birmingham on 10/3/24.
//

import Foundation
import SwiftUI
import ChessKit

struct Piece {
    var id: Character?
    var icon: Image?
}

struct Move : Equatable {
    var source : Square
    var destination : Square
}

struct Puzzle {
    var pieces = [[Piece]]()
    var moves = [Move]()
    var orientation: Bool = true
    var rating: String = "-1"
    var fen: String = ""
}

func parsePuzzle(selectedPuzzle: [String]) -> Puzzle {
    var puzzle = Puzzle()
    puzzle.pieces = parseFEN(fen: selectedPuzzle[0])
    puzzle.orientation = {selectedPuzzle[0].split(separator: " ")[1] == "b" ? true : false}()
    puzzle.moves = [Move]()
    for str in selectedPuzzle[1].split(separator: " ") {
        var source = Square(String(str.prefix(2)))
        var destination = Square(String(str.suffix(2)))
        puzzle.moves.append(Move(source: source, destination: destination))
    }
    puzzle.rating = selectedPuzzle[2]
    puzzle.fen = selectedPuzzle[0]
    return puzzle
}

func parseFEN(fen: String) -> [[Piece]] {
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
    var pieces: [[Piece]] = [[],[],[],[],[],[],[],[]]
    
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
                pieces[row].append(Piece())
            }
            // checks if all pieces have been read
        } else if char == " " {
            break
            // adds a piece
        } else {
            pieces[row].append(Piece(
                id: char,
                icon: pieceImages[char]))
        }
    }
    
    return pieces
}
