//
//  Colors.swift
//  ChessUI
//
//  Created by Evan Rohan on 10/21/24.
//
import SwiftUI

class colors {
    
    static let lightGreen = Color(red: 86/255, green: 160/255, blue: 84/255)
    static let darkGreen = Color(red: 0/255, green: 51/255, blue: 0/255)
    static let vermontGreen = Color(red: 0/255, green: 120/255, blue: 52/255)
    static let gray = Color(red: 215/255, green: 210/255, blue: 203/255)
    static let black = Color(red: 48/255, green: 48/255, blue: 48/255)
    static let orange = Color(red: 184 / 255, green: 84 / 255, blue: 35 / 255)
    static let yellow = Color(red: 245 / 255, green: 179 / 255, blue: 36 / 255)
    
    // PuzzleView colors
    static let whiteSquares = Color.white
    static let blackSquares = Color(red: 0.55, green: 0.43, blue: 0.07)
    static let highlightColor = Color.green.opacity(0.5)
    static let selectedColor = Color.yellow.opacity(0.7)
    static let hintColor = Color.blue.opacity(0.5)
    static let badColor = Color.red.opacity(0.75)
    
    // color themes
    // brown
    static let lightBrown = Color(red: 0.94, green: 0.85, blue: 0.71)
    static let darkBrown = Color(red: 0.70, green: 0.53, blue: 0.38)
    
    // blue
    static let lightBlue = Color(red: 0.53, green: 0.61, blue: 0.69)
    static let darkBlue = Color(red: 0.36, green: 0.47, blue: 0.55)
    
    // purple
    static let lightPurple = Color(red: 0.62, green: 0.56, blue: 0.69)
    static let darkPurple = Color(red: 0.49, green: 0.29, blue: 0.55)
}
