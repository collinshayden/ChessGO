//
//  ContentView.swift
//  ChessUI
//
//  Created by James Birmingham on 9/26/24.
//

import SwiftUI

struct piece {
    var id: Character?
    var icon: Image?
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
    var col = 0
    
    for char in fen {
        // checks if the row has ended
        if char == "/" {
            row += 1
            col = 0
        // checks if there isn't a piece at a position
        } else if char.isNumber {
            let n = Int(String(char))
            for _ in 0..<n! {
                pieces[row].append(piece())
            }
            col += n!
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

// Style for the squares (buttons) on the chess board
struct boardSquare: ButtonStyle {
    var color: Bool
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: ContentView.squareSize, height: ContentView.squareSize)
            .background(color ? ContentView.whiteSquares : ContentView.blackSquares)
            .foregroundColor(color ? ContentView.blackSquares : ContentView.whiteSquares)
            .border(color ? ContentView.whiteSquares : ContentView.blackSquares)
    }
}

// View controller for the chess board
struct board: View {
    static let cols = ["A", "B", "C", "D", "E", "F", "G", "H"]
    var pieces: [[piece?]]
    
    // places squares from perspective of black or white player
    var boardOrientation = { (row: Int, col: Int) -> Bool in
        if (ContentView.white) {
            return (col+row)%2 == 0
        } else {
            return (col+row)%2 == 1
        }
    }
    
    // places row labels from perspective of black or white player
    var labelOrientation = { (row: Int) -> Int in
        if (ContentView.white) {
            return row
        } else {
            return 9-row
        }
    }
    
    // flips col and row values if in black orientation
    var pieceOrientation = { (index: Int) -> Int in
        if (ContentView.white) {
            return index
        } else {
            return 7-index
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                // this is just white space to align the col text labels with the board
                Text("").frame(width: ContentView.boardLabel)
                // col labels
                ForEach(1..<9) { col in
                    Text(board.cols[labelOrientation(col)-1])
                        .frame(
                            width: ContentView.squareSize,
                            height: ContentView.squareSize,
                            alignment: .center)
                }
            }
            // make a square for each row, col in an 8x8 grid
            ForEach(1..<9) {row in
                HStack(spacing: 0) {
                    // row lables
                    Text(String(labelOrientation(row)) + "  ")
                        .frame(
                            width: ContentView.boardLabel,
                        height: ContentView.squareSize,
                        alignment: .center)
                    ForEach(1..<9) {col in
                        // squares
                        Button(action: {
                            print(
                                board.cols[col-1] + String(row))
                        }) {
                            if pieces[pieceOrientation(row-1)][pieceOrientation(col-1)]?.icon != nil {
                                pieces[pieceOrientation(row-1)][pieceOrientation(col-1)]?.icon?
                                    .resizable()
                            } else {
                                Text("")
                            }
                        }
                        .buttonStyle(
                            boardSquare(color: boardOrientation(row, col)))
                    }
                }
            }
        }
    }
}


struct ContentView: View {
    // this controls what pieces are displayed on the board
    @State var fen = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
    
    // determines which orientation the board should be displayed
    static let white = true
    
    // colors for board squares
    static let whiteSquares = Color.white
    static let blackSquares = Color(red: 0.55, green: 0.43, blue: 0.07)
    
    // controls size of squares
    static let boardLabel: CGFloat = 30
    static let squareSize = floor((UIScreen.main.bounds.size.width - ContentView.boardLabel)/8)
    
    var body: some View {
        Text("ChessGo").font(.largeTitle).padding(40)
        Button("Test") {
            fen = "rnbqkbnr/pppppppp/8/8/4P3/8/PPPPPPPP/RNBQKBNR b KQkq e3 0"
        }
        Button("Test1") {
            fen = "rnbqkbnr/pppppppp/8/8/3P4/8/PPPPPPPP/RNBQKBNR b KQkq e3 0"
        }
        Button("Test2") {
            fen = "8/8/5k2/8/1K6/8/PpPpPpPp/8 b KQkq e3 0"
        }
        board(pieces: parseFEN(fen: fen))
    }
}

#Preview {
    ContentView()
}
