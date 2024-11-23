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
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    colors.darkGreen,
                    colors.vermontGreen,
                    colors.lightGreen
                ]),
                startPoint: .top,
                endPoint: .bottom
            ).ignoresSafeArea(.all)
            VStack {
                Text("Puzzle Rush").font(.largeTitle).padding(40)
                Spacer()
                if !start {
                    RoundedButtonView(buttonText: "Start!", action: {  withAnimation {
                        start.toggle()
                    }})
                    Spacer()
                    RoundedButtonView(buttonText: "Back to Map", action: {withAnimation {
                        showPuzzleRush.toggle()
                        showMap.toggle()
                    }})
                }
                else {
                    if puzzleRushStore.puzzles.count == 0 {
                        Text("Loading Puzzles...").font(.largeTitle).padding(40)
                        Text("Please wait").font(.largeTitle).padding(40)
                    }
                    else {
                        if puzzleRushIndex! < puzzleRushStore.puzzles.count {
                            let logic = BoardLogic(selectedPuzzle: puzzleRushStore.puzzles[puzzleRushIndex!])
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
                                    
                                    RoundedButtonView(buttonText: "Restart", action: {
                                        puzzleRushEnd = false
                                        puzzleRushIndex = 0
                                    })
                                }.animation(.easeInOut, value: puzzleRushEnd)
                            }
                        }
                        else {
                            Text("Congratulations!").font(.largeTitle).padding(40)
                            Text("You reached the max puzzle rush score of \(puzzleRushStore.puzzles.count)!")
                        }
                    }
                    RoundedButtonView(buttonText: "Back to Map", action: {withAnimation {
                        showPuzzleRush.toggle()
                        showMap.toggle()
                        Task {
                            puzzleRushStore.puzzles = await fireBaseService.getPuzzleRushPuzzles()
                        }
                    }})
                }
            }
        }
            .environment(\.font, .custom("League Spartan", size: 32))
            .foregroundColor(.white)
    }
}

#Preview {
    @State var showPuzzleRush = true
    @State var showMap = true
    return PuzzleRushView(showPuzzleRush: $showPuzzleRush, showMap: $showMap).environmentObject(Settings())
}
