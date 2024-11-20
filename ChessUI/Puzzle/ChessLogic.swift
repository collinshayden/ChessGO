//
//  ChessLogic.swift
//  ChessUI
//
//  Created by James Birmingham on 10/3/24.
//

import Foundation
import SwiftUI
import ChessKit

struct Move : Equatable {
    var source : Square
    var destination : Square
    var promotion: Character?
}

class Puzzle: ObservableObject {
    @Published var pieces = [[Character]]()
    @Published var moves = [Move]()
    @Published var orientation: Bool
    @Published var rating: Int
    @Published var fen: String
    @Published var themes: [String]
    
    // selected puzzle format: ["rating", "FEN", "solution", "themes"]
    // ["1760","q3k1nr/1pp1nQpp/3p4/1P2p3/4P3/B1PP1b2/B5PP/5K2 b k - 0 17","e8d7 a2e6 d7d8 f7f8", "placeholder themes"]
    init(_ rating: Int = 1760, _ fen: String = "1rb2rk1/q5P1/4p2p/3p3p/3P1P2/2P5/2QK3P/3R2R1 b - - 0 29", _ moves: String = "f8f7 c2h7 g8h7 g7g8q", _ themes: String = "placeholder themes") {
        self.rating = rating
        self.fen = fen
        self.pieces = parseFEN(fen)
        self.orientation = {fen.split(separator: " ")[1] == "b" ? true : false}()
        self.themes = themes.split(separator: " ").map{String($0)}
        self.moves = [Move]()
        for str in moves.split(separator: " ") {
            let characters = Array(str)
            let source = Square(String(characters[...1]))
            let destination = Square(String(characters[2...3]))
            if (characters.count == 4) {
                self.moves.append(Move(source: source, destination: destination))
            } else {
                let piece = characters[4]
                self.moves.append(Move(source: source, destination: destination, promotion: piece))
            }
        }
    }
}

func parseFEN(_ fen: String) -> [[Character]] {
    // array of arrays which holds pieces [row][col]
    var pieces: [[Character]] = [[],[],[],[],[],[],[],[]]
    
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
                pieces[row].append(Character("0"))
            }
            // checks if all pieces have been read
        } else if char == " " {
            break
            // adds a piece
        } else {
            pieces[row].append(char)
        }
    }
    
    return pieces
}

class PuzzleRushStore: ObservableObject {
    @Published var puzzles: [Puzzle] = []
}
