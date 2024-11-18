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
    var color: Color
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: PuzzleView.squareSize, height: PuzzleView.squareSize)
            .background(color)
            .foregroundColor(color)
            .border(color)
    }
}

// View controller for the chess board
struct board: View {
    static let colLabels = ["h", "g", "f", "e", "d", "c", "b", "a"]
    @ObservedObject var logic: BoardLogic
    @State var showHints: Int = 0
    @State private var displayElo: Float = 0
    @EnvironmentObject var user: UserService
    @EnvironmentObject var firebaseService: FireBaseService
    @EnvironmentObject var settings: Settings
    @Binding var puzzleRushIndex: Int?
    @Binding var puzzleRushEnd: Bool?
    @State var promotionSelection: Piece.Kind = .pawn

    // orient the rows based on board orientation
    var rows: [Int] {
        logic.puzzle.orientation ? Array(1...8) : Array(1...8).reversed()
    }
    
    // orient the cols based on board orientation
    var cols: [String] {
        logic.puzzle.orientation  ? board.colLabels.reversed() : board.colLabels
    }
    
    // orients row/col indices based on board orientation
    func orientIndices(_ row: Int, _ col: Int) -> (Int, Int) {
        let orientedRow = logic.puzzle.orientation ? 7 - row : row
        let orientedCol = logic.puzzle.orientation ? col : 7 - col
        return (orientedRow, orientedCol)
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                
                Text("Puzzle Rating: \(logic.puzzle.rating)")
                    .bold()
                
                Picker(selection: $promotionSelection, label: Text("Promote")) {
                    let icons = logic.puzzle.orientation ? Constants.whiteImages : Constants.blackImages
                    ForEach(Array(icons.keys), id: \.self) {key in
                        icons[key]
                    }
                }
                
                HStack(spacing: 0) {
                    // this is just white space to align the col text labels with the board
                    Text("").frame(width: PuzzleView.boardLabel)
                    // col labels
                    ForEach(0..<8) { col in
                        Text(cols[col])
                            .frame(
                                width: PuzzleView.squareSize,
                                height: PuzzleView.squareSize,
                                alignment: .center)
                    }
                }
                // make a square for each row, col in an 8x8 grid
                ForEach((0..<8).reversed(), id: \.self) {row in
                    HStack(spacing: 0) {
                        // row lables
                        Text(String(rows[row]) + "  ")
                            .frame(
                                width: PuzzleView.boardLabel,
                                height: PuzzleView.squareSize,
                                alignment: .center)
                        ForEach(0..<8) {col in
                            let coord = cols[col] + String(rows[row])
                            let highlight = logic.lastMoveCoords?.contains(coord) ?? false
                            let badMove = logic.secondClickedSquare == Square(coord) && logic.puzzleFailed
                            let selected = logic.firstClickedSquare == Square(coord)
                            // hint=0 doesn't highlight, =1 shows source, =2 shows source/destination
                            let hint = self.showHints == 0 ? false : self.showHints == 1 ? logic.getHintSquares()[0] == coord : logic.getHintSquares().contains(coord)
                            // light/dark square assignment
                            let defaultSquareColor = (col+row) % 2 == 1 ? settings.boardTheme.lightColor : settings.boardTheme.darkColor
                            // set square background color
                            let squareColor = badMove ? colors.badColor : selected ? colors.selectedColor : hint ? colors.hintColor : highlight ? colors.highlightColor : defaultSquareColor
                            // square button actions
                            Button(action: {
                                if !logic.promoting && !logic.puzzleFailed {
                                    var mv = logic.click(pos: coord)
                                }
                                self.showHints = 0
                            }) {
                                let (orientedRow, orientedCol) = orientIndices(row, col)
                                if logic.getPieces()[orientedRow][orientedCol] != "0" {
                                    ZStack{
                                        if logic.checkLegalMove(pos: coord) {
                                            Circle()
                                                .stroke(Color(red: 0.5, green: 0.5, blue: 0.5), lineWidth: 4)
                                                .frame(
                                                    width: PuzzleView.squareSize-7,
                                                    height: PuzzleView.squareSize-7)
                                        }
                                        
                                        Constants.pieceImages[logic.getPieces()[orientedRow][orientedCol]]?
                                            .resizable()
                                    }
                                } else if logic.checkLegalMove(pos: coord) {
                                    Circle()
                                        .fill(Color(red: 0.5, green: 0.5, blue: 0.5))
                                        .frame(width: PuzzleView.squareSize*0.3,
                                               height: PuzzleView.squareSize*0.3)
                                } else {
                                    Text("")
                                }
                                
                            }
                            .buttonStyle(
                                boardSquare(color: squareColor))
                        }
                    }
                }
                if puzzleRushIndex == nil {
                    Text("\(logic.msg)")
                        .padding(10)
                    // doesnt allow user to get hints after they have finished the puzzle
                    if !logic.puzzleComplete {
                        Button(showHints == 0 ? "Get a Hint" : "Second Hint") {
                            showHints += 1
                        }
                        .padding(10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    
                    // doesnt allow user to get hints after they have finished the puzzle
                    if logic.puzzleFailed {
                        Button("Retry") {
                            logic.reset()
                        }
                        .padding(10)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                else {
                    if logic.puzzleComplete {
                        Text("Puzzle Complete!").onAppear {
                            puzzleRushIndex! += 1
                        }
                    }
                    if logic.puzzleFailed {
                        Text("Puzzle Failed").onAppear {
                            puzzleRushEnd! = true
                        }
                    }
                }
                
            }
            .blur(radius: {logic.puzzleComplete && puzzleRushIndex == nil ? 18 : 0}())
            .animation(.easeInOut, value: logic.puzzleComplete)
            
            if logic.puzzleComplete && puzzleRushIndex == nil {
                GameOverView(board: logic)
            }
        }
    }
}


struct PuzzleView: View {
    @EnvironmentObject var user: UserService
    @EnvironmentObject var firebaseService: FireBaseService
    // this controls what pieces are displayed on the board
    @StateObject var logic: BoardLogic
    // showChess and showMap bindings are to toggle between views via button
    @Binding var showChess: Bool
    @Binding var showMap: Bool
    
    init(puzzle: Puzzle, showChess: Binding<Bool>, showMap: Binding<Bool>) {
        _logic = StateObject(wrappedValue: BoardLogic(selectedPuzzle: puzzle))
        _showChess = showChess
        _showMap = showMap
    }
    // determines which orientation the board should be displayed
    static let boardLabel: CGFloat = 30
    static let squareSize = floor((UIScreen.main.bounds.size.width - PuzzleView.boardLabel)/8)
    
    
    var body: some View {
        VStack {
            Text("ChessGo").font(.largeTitle).padding(40)
            board(logic: logic, puzzleRushIndex: .constant(nil), puzzleRushEnd: .constant(nil))
            
            Button(action: {
                withAnimation {
                    showChess.toggle()
                    showMap.toggle()
                }
            }) {
                Text("Back to Map")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            
        }
    }
}

#Preview {
    @State var showChess = true
    @State var showMap = true
    return PuzzleView(puzzle: Puzzle(), showChess: $showChess, showMap: $showMap)
}
