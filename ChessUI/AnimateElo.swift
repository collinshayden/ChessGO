//
//  AnimateElo.swift
//  ChessUI
//
//  Created by James Birmingham on 11/4/24.
//

//import Foundation
import SwiftUI

class AnimateElo:ObservableObject {
    @Published var displayElo: Float
    @Published var finished = false
    // 10 seconds
    let frames = 600
    let startingElo: Float
    let endElo: Float
    var x: Float = 0
    let dX: Float
    
    init(startingElo: Float, endElo: Float) {
        self.startingElo = startingElo
        displayElo = startingElo
        self.endElo = endElo
        dX = Float.pi / Float(frames)
    }
}


func modifiedSin(x: Double) -> Double {
    return (sin(Double.pi * (x-0.5))+1)/2
}


// based on https://pypi.org/project/elo/
// https://en.wikipedia.org/wiki/Elo_rating_system
// takes user rating and puzzle rating,
func updateElo(userRating: Float, userKFactor: Float, puzzleRating: Int, correct: Bool) -> Float {
    let score: Float = correct ? 1.0 : 0.0
    let beta = 200
    let f_factor = Float(2 * beta)
    let diff = Float(puzzleRating) - Float(userRating)
    let expectedScore = 1 / (1 + pow(10, diff / f_factor))
    let adjust = score - expectedScore
    return userRating + userKFactor * adjust
}
