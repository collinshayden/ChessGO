//
//  PuzzleRushView.swift
//  ChessUI
//
//  Created by Hayden Collins on 11/12/24.
//

import SwiftUI

struct PuzzleRushView: View {
    @EnvironmentObject var fireBaseService: FireBaseService
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var puzzleRushStore: PuzzleRushStore
    
    @State var puzzleRushIndex: Int? = 0
    @State var puzzleRushEnd: Bool? = false
    @Binding var showPuzzleRush: Bool
    @Binding var showMap: Bool
    @State var start: Bool = false
    
    
    var body: some View {
        VStack {
            Text("Puzzle Rush").font(.largeTitle).padding(40)
            
            if !start {
                Button(action: {
                    withAnimation {
                        start.toggle()
                    }
                }) {
                    Text("Start!")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            else {
                if puzzleRushStore.puzzles.count == 0 {
                    Text("Loading Puzzles...").font(.largeTitle).padding(40)
                    Text("Please wait").font(.largeTitle).padding(40)
                }
                else {
                    if puzzleRushIndex! < puzzleRushStore.puzzles.count {
                        var logic = BoardLogic(selectedPuzzle: puzzleRushStore.puzzles[puzzleRushIndex!])
                        if !puzzleRushEnd! {
                            Text("Score: \(puzzleRushIndex!)").font(.largeTitle).padding(40)
                            board(logic: logic, puzzleRushIndex: $puzzleRushIndex, puzzleRushEnd: $puzzleRushEnd)
                        }
                        else {
                            VStack {
                                Text("Game Over").font(.largeTitle).padding(40).onAppear {
                                    Task {
                                        puzzleRushStore.puzzles = await fireBaseService.getPuzzleRushPuzzles()
                                    }
                                }
                                Text("Your Score: \(puzzleRushIndex!)").font(.largeTitle).padding(40)
                            }.animation(.easeInOut, value: puzzleRushEnd)
                        }
                    }
                    else {
                        Text("Congratulations!").font(.largeTitle).padding(40)
                        Text("You reached the max puzzle rush score of \(puzzleRushStore.puzzles.count)!")
                    }
                }
                Button(action: {
                    puzzleRushEnd = false
                    puzzleRushIndex = 0
                }) {
                    Text("Restart")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            Button(action: {
                withAnimation {
                    showPuzzleRush.toggle()
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
        }
    }
}

#Preview {
    @State var showPuzzleRush = true
    @State var showMap = true
    return PuzzleRushView(showPuzzleRush: $showPuzzleRush, showMap: $showMap).environmentObject(Settings())
}
