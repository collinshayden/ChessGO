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
    
    
    var body: some View {
        VStack {
            Text("Puzzle Rush").font(.largeTitle).padding(40)
            Text("\(puzzleRushIndex!+1)").font(.largeTitle).padding(40)
            
            if puzzleRushIndex! < puzzleRushStore.puzzles.count {
                var logic = BoardLogic(selectedPuzzle: puzzleRushStore.puzzles[puzzleRushIndex!])
                if !puzzleRushEnd! {
                    board(logic: logic, puzzleRushIndex: $puzzleRushIndex, puzzleRushEnd: $puzzleRushEnd)
                }
                else {
                    Text("Game Over")
                    Text("Score: \(puzzleRushIndex!)").onAppear {
                        Task {
                            puzzleRushStore.puzzles = await fireBaseService.getPuzzleRushPuzzles()
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
            }
            else {
                Text("Congratulations, you reached the max puzzle rush score of \(puzzleRushStore.puzzles.count)!")
            }
        }
    }
}

#Preview {
    @State var showPuzzleRush = true
    @State var showMap = true
    return PuzzleRushView(showPuzzleRush: $showPuzzleRush, showMap: $showMap).environmentObject(Settings())
}
