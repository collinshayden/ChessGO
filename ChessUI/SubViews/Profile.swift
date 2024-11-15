//
//  Profile.swift
//  ChessUI
//
//  Created by Felix Walberg on 11/14/24.
//

import Foundation
import SwiftUI

class Profile: ObservableObject {
    @Published var pieceChoice: Int = 0
    let pieces: [Image] = [
        Image(.chessPdt45Svg),
        Image(.chessRdt45Svg),
        Image(.chessNdt45Svg),
        Image(.chessBdt45Svg),
        Image(.chessQdt45Svg),
        Image(.chessKdt45Svg),
        Image(.chessPlt45Svg),
        Image(.chessRlt45Svg),
        Image(.chessNlt45Svg),
        Image(.chessBlt45Svg),
        Image(.chessQlt45Svg),
        Image(.chessKlt45Svg)
    ]
}
