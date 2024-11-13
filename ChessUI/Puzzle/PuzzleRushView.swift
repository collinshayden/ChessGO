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
    @Binding var showPuzzleRush: Bool
    @Binding var showMap: Bool
    
    
    var body: some View {
        VStack {
            Text("Puzzle Rush").font(.largeTitle).padding(40)
            
            board(logic: BoardLogic(selectedPuzzle: puzzleRushStore.puzzles.first!))
        }
    }
}

#Preview {
    @State var showPuzzleRush = true
    @State var showMap = true
    return PuzzleRushView(showPuzzleRush: $showPuzzleRush, showMap: $showMap).environmentObject(Settings())
}
