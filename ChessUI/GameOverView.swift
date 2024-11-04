//
//  GameOverView.swift
//  ChessUI
//
//  Created by James Birmingham on 11/4/24.
//

import SwiftUI

struct GameOverView: View {
    @ObservedObject var logic: BoardLogic
    @ObservedObject private var eloAnimator: AnimateElo
    let k: Float
    let startElo: Float
    let newElo: Float
    
    init (startElo: Float, k: Float, board: BoardLogic) {
        self.startElo = startElo
        self.k = k
        newElo = updateElo(userRating: startElo, userKFactor: k, puzzleRating: Int(board.puzzle.rating) ?? 0, correct: true)
        eloAnimator = AnimateElo(startingElo: startElo, endElo: newElo)
        logic = board
    }
    
    var body: some View {
        VStack(spacing: 6) {
            if eloAnimator.finished {
                Text("Good Job! ")
                Text("Old rating: \(Int(round(startElo)))")
                Text("New rating: \(Int(round(newElo)))")
                Button ("Run that back") {
                    logic.reset()
                }
                .padding(10)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            } else {
                Text("Elo \(Int(round(eloAnimator.displayElo)))")
                Button ("Show new elo") {
                    withAnimation(.sinAnimation) {
                        eloAnimator.displayElo = eloAnimator.endElo
                    }
                }
            }
        }
        .padding(10)
        .font(.system(size: 36))
        .bold()
    }
}

struct SinAnimation: CustomAnimation {
    let duration: TimeInterval
    
    func animate<V>(value: V, time: TimeInterval, context: inout AnimationContext<V>) -> V? where V : VectorArithmetic {
        guard time < duration else {return nil}
        print("t/d: \(time/duration) func: \(modifiedSin(x: time/duration)) expected val: \(Int(round(1700 + (1760-1700)*modifiedSin(x: time/duration))))")
        return value.interpolated(towards: value, amount: modifiedSin(x: time/duration))
    }
}

extension Animation {
    static func sinAnimation(duration: TimeInterval, target: Double) -> Animation { Animation(SinAnimation(duration: duration)) }
                                                                       
    static var sinAnimation: Animation { Animation(SinAnimation(duration: 10)) }
}

#Preview {
    GameOverView(startElo: 1700, k: 100, board: BoardLogic(selectedPuzzle: Puzzle(selectedPuzzle: ["q3k1nr/1pp1nQpp/3p4/1P2p3/4P3/B1PP1b2/B5PP/5K2 b k - 0 17","e8d7 a2e6 d7d8 f7f8","1760"])))
}
