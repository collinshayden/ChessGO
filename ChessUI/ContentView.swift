//
//  ContentView.swift
//  ChessUI
//
//  Created by James Birmingham on 9/26/24.
//

import SwiftUI
import ChessKit

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
    @Binding var clickedSquare: Square?
    @Binding var legalMoves: [Square]
    static let cols = ["h", "g", "f", "e", "d", "c", "b", "a"]
    var pieces: [[piece?]]
    
    // places row labels from perspective of black or white player
    var labelOrientation = { (coord: Int) -> Int in
        if (ContentView.white) {
            return 9-coord
        } else {
            return coord
        }
    }
    
    // flips col and row values if in black orientation
    var pieceOrientation = { (index: Int) -> Int in
        if (ContentView.white) {
            return 7-index
        } else {
            return index
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
            ForEach((1..<9).reversed(), id: \.self) {row in
                HStack(spacing: 0) {
                    // row lables
                    Text(String(labelOrientation(9-row)) + "  ")
                        .frame(
                            width: ContentView.boardLabel,
                        height: ContentView.squareSize,
                        alignment: .center)
                    ForEach(1..<9) {col in
                        // squares
                        Button(action: {
                            //save square coordinate of clicked button
                            clickedSquare = Square(board.cols[labelOrientation(col)-1] + String(labelOrientation(9-row)))

                        }) {
                            if pieces[pieceOrientation(row-1)][pieceOrientation(8-col)]?.icon != nil {
                                pieces[pieceOrientation(row-1)][pieceOrientation(8-col)]?.icon?
                                    .resizable()
                            } else {
                                Text(board.cols[labelOrientation(col)-1] + String(labelOrientation(9-row)))
//                                Text(" ")
                            }
                            
                        }
                        .buttonStyle(
                            boardSquare(color: (col+row)%2 == 1))
                    }
                }
            }
        }
    }
}


struct ContentView: View {
    // this controls what pieces are displayed on the board
    @State var fen = "r4rk1/pp3ppp/2n1b3/q1pp2B1/8/P1Q2NP1/1PP1PP1P/2KR3R w - - 0 15"
    // clicked squares
    @State private var clickedSquare: Square?
    @State private var legalMoves: [Square] = [] // Stores the legal moves

    // determines which orientation the board should be displayed
    static let white = true
    
    // colors for board squares
    static let whiteSquares = Color.white
    static let blackSquares = Color(red: 0.55, green: 0.43, blue: 0.07)
    
    // controls size of squares
    static let boardLabel: CGFloat = 30
    static let squareSize = floor((UIScreen.main.bounds.size.width - ContentView.boardLabel)/8)
    
    
    
    // moves
    
    
    var body: some View {
        Text("ChessGo").font(.largeTitle).padding(40)

        board(clickedSquare: $clickedSquare, legalMoves: $legalMoves, pieces: parseFEN(fen: fen))
        
        var board_backend = Board(position: Position(fen: fen)!)
//        Move(result: Move.Result, piece: <#T##Piece#>, start: <#T##Square#>, end: <#T##Square#>)
//        board_backend.move(pieceAt: Square("c3"), to: Square("d5"))
//        board_backend.position.fen
        
        if let square = clickedSquare {
            let moves = board_backend.legalMoves(forPieceAt: square)
            if let square = clickedSquare {
                            Text("Clicked Square: \(square.notation)")
                        }
            Text("Legal Moves: \(moves.count)")
                            ForEach(moves, id: \.self) { square in
                                Text("1. \(square.notation)") // Customize the display of each move as needed
                            }
        }
    }
}

#Preview {
    ContentView()
}
