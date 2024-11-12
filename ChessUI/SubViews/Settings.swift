//
//  Settings.swift
//  ChessUI
//
//  Created by Hayden Collins on 11/12/24.
//

import SwiftUI

struct Difficulty: Hashable {
    let value: Int
    let label: String
}

struct BoardTheme: Hashable {
    let lightColor: Color
    let darkColor: Color
}

class Settings: ObservableObject {
    @Published var puzzleDifficulty: Int
    @Published var boardTheme: BoardTheme
    
    let difficulties: [Difficulty] = [
        Difficulty(value: -600, label: "Easiest"),
        Difficulty(value: -300, label: "Easier"),
        Difficulty(value: 0, label: "Normal"),
        Difficulty(value: 300, label: "Harder"),
        Difficulty(value: 600, label: "Hardest"),
    ]
    
    // TODO add more themes
    let themes: [BoardTheme] = [
        BoardTheme(lightColor: colors.lightBlue, darkColor: colors.darkBlue),
        BoardTheme(lightColor: colors.lightPurple, darkColor: colors.darkPurple),
        BoardTheme(lightColor: colors.lightBrown, darkColor: colors.darkBrown),
    ]
    
    init() {
        self.puzzleDifficulty = 0
        self.boardTheme = BoardTheme(lightColor: colors.lightBlue, darkColor: colors.darkBlue)
    }
}
