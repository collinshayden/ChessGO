//
//  PuzzleView.swift
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
            .frame(width: PuzzleView.squareSize, height: PuzzleView.squareSize)
            .background(color ? PuzzleView.whiteSquares : PuzzleView.blackSquares)
            .foregroundColor(color ? PuzzleView.blackSquares : PuzzleView.whiteSquares)
            .border(color ? PuzzleView.whiteSquares : PuzzleView.blackSquares)
    }
}

// View controller for the chess board
struct board: View {
    static let cols = ["h", "g", "f", "e", "d", "c", "b", "a"]
    @ObservedObject var logic: BoardLogic
    
    // places row labels from perspective of black or white player
    var labelOrientation = { (coord: Int) -> Int in
        if (PuzzleView.white) {
            return 9-coord
        } else {
            return coord
        }
    }
    
    // flips col and row values if in black orientation
    var pieceOrientation = { (index: Int) -> Int in
        if (PuzzleView.white) {
            return 7-index
        } else {
            return index
        }
    }
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                // this is just white space to align the col text labels with the board
                Text("").frame(width: PuzzleView.boardLabel)
                // col labels
                ForEach(1..<9) { col in
                    Text(board.cols[labelOrientation(col)-1])
                        .frame(
                            width: PuzzleView.squareSize,
                            height: PuzzleView.squareSize,
                            alignment: .center)
                }
            }
            // make a square for each row, col in an 8x8 grid
            ForEach((1..<9).reversed(), id: \.self) {row in
                HStack(spacing: 0) {
                    // row lables
                    Text(String(labelOrientation(9-row)) + "  ")
                        .frame(
                            width: PuzzleView.boardLabel,
                            height: PuzzleView.squareSize,
                            alignment: .center)
                    ForEach(1..<9) {col in
                        let coord = board.cols[labelOrientation(col)-1] + String(labelOrientation(9-row))
                        // squares
                        Button(action: {
                            logic.click(pos: coord)
                        }) {
                            if logic.getPieces()[pieceOrientation(row-1)][pieceOrientation(8-col)].icon != nil {
                                
                                ZStack{
                                    if logic.checkLegalMove(pos: coord) {
                                        Circle()
                                            .stroke(Color(red: 0.5, green: 0.5, blue: 0.5), lineWidth: 4)
                                            .frame(
                                                width: PuzzleView.squareSize-7,
                                                height: PuzzleView.squareSize-7)
                                    }
                                    logic.getPieces()[pieceOrientation(row-1)][pieceOrientation(8-col)].icon?
                                        .resizable()
                                }
                            } else if logic.checkLegalMove(pos: coord) {
                                Circle()
                                    .fill(Color(red: 0.5, green: 0.5, blue: 0.5))
                                    .frame(width: PuzzleView.squareSize*0.3,
                                           height: PuzzleView.squareSize*0.3)
                            } else {
                                Text(coord)
                            }
                            
                        }
                        .buttonStyle(
                            boardSquare(color: (col+row)%2 == 1))
                    }
                }
            }
        }
        Text("Puzzle Rating: \(logic.puzzle.rating)")
    }
}


struct PuzzleView: View {
    // this controls what pieces are displayed on the board
    @StateObject var logic: BoardLogic = BoardLogic(selectedPuzzle: ["q3k1nr/1pp1nQpp/3p4/1P2p3/4P3/B1PP1b2/B5PP/5K2 b k - 0 17","e8d7 a2e6 d7d8 f7f8","1760"])
    // determines which orientation the board should be displayed
    static let white = true
    
    // colors for board squares
    static let whiteSquares = Color.white
    static let blackSquares = Color(red: 0.55, green: 0.43, blue: 0.07)
    static let startHighlight = Color.blue
    static let targetHighlight = Color.red
    
    // controls size of squares
    static let boardLabel: CGFloat = 30
    static let squareSize = floor((UIScreen.main.bounds.size.width - PuzzleView.boardLabel)/8)
    
    
    var body: some View {
        Text("ChessGo").font(.largeTitle).padding(40)
        board(logic: logic)
    }
}

#Preview {
    PuzzleView()
}
