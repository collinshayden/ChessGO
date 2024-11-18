//
//  Constants.swift
//  ChessUI
//
//  Created by James Birmingham on 11/18/24.
//

import Foundation
import SwiftUI
import ChessKit

class Constants {
    // piece id to icon dictionary
    static let pieceImages: Dictionary<Character, Image> = [
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
    
    static let whiteImages: Dictionary<Character, Image> = [
        "p": Image(.chessPdt45Svg),
        "r": Image(.chessRdt45Svg),
        "n": Image(.chessNdt45Svg),
        "b": Image(.chessBdt45Svg),
        "q": Image(.chessQdt45Svg),
        "k": Image(.chessKdt45Svg)
    ]
    
    static let blackImages: Dictionary<Character, Image> = [
        "P": Image(.chessPlt45Svg),
        "R": Image(.chessRlt45Svg),
        "N": Image(.chessNlt45Svg),
        "B": Image(.chessBlt45Svg),
        "Q": Image(.chessQlt45Svg),
        "K": Image(.chessKlt45Svg)
    ]
    
    // piece id to piece kind dictionary
    static let idKinds: Dictionary<Character, Piece.Kind> = [
        "p": .pawn,
        "r": .rook,
        "n": .knight,
        "b": .bishop,
        "q": .queen,
        "k": .king,
        "P": .pawn,
        "R": .rook,
        "N": .knight,
        "B": .bishop,
        "Q": .queen,
        "K": .king
    ]
}
