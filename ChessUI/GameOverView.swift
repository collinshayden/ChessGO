//
//  GameOverView.swift
//  ChessUI
//
//  Created by James Birmingham on 11/4/24.
//

import SwiftUI

struct GameOverView: View {
    @ObservedObject var logic: BoardLogic
    @State var displayElo: Double
    @State var finished = false
    let k: Double
    let startElo: Double
    let newElo: Double
    
    init (startElo: Double, k: Double, board: BoardLogic) {
        self.startElo = startElo
        self.k = k
        newElo = updateElo(userRating: startElo, userKFactor: k, puzzleRating: Int(board.puzzle.rating) ?? 0, correct: true)
        displayElo = startElo
        logic = board
    }
    
    var body: some View {
        VStack(spacing: 6) {
            Text("Good Job! ")
                .opacity({finished ? 1 : 0}())
            Text("Old rating: \(Int(round(startElo)))")
                .opacity({finished ? 1 : 0}())

            HStack {
                Text("New rating:")
                Text("\(Int(round(displayElo)))")
                    .numericAnimation(number: displayElo)
                    .onAppear {
                        withAnimation(.sinAnimation(duration: log10(newElo-startElo)+3)) {
                            displayElo = newElo
                        } completion: {
                            withAnimation(.sinAnimation(duration: 2)) {
                                finished = true
                            }
                        }
                    }
            }
            
            Button ("Run that back") {
                logic.reset()
            }
            .padding(10)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .opacity({finished ? 1 : 0}())

        }
        .padding(10)
        .font(.system(size: 36))
        .bold()
    }
}

// https://levelup.gitconnected.com/swiftui-animate-number-changes-3-ways-a9b3730f8ad8
extension View {
    func numericAnimation(number: Double) -> some View {
        modifier(AnimatableNumberModifier(animatableData: number))
    }
}

struct AnimatableNumberModifier: Animatable, ViewModifier {
    var animatableData: Double {
        willSet {
            increasing = newValue > animatableData
        }
    }
    var increasing: Bool = false
    
    func body(content: Content) -> some View {
        if increasing {
            Text("\(Int(floor(animatableData)))")
        } else {
            Text("\(Int(ceil(animatableData)))")
        }
    }
}

// https://swiftui-lab.com/swiftui-animations-part6/
struct SinAnimation: CustomAnimation {
    let duration: TimeInterval
    func animate<V>(value: V, time: TimeInterval, context: inout AnimationContext<V>) -> V? where V : VectorArithmetic {
        guard time < duration else {return nil}
        return value.scaled(by: modifiedSin(x: time/duration))
    }
}

extension Animation {
    static func sinAnimation(duration: TimeInterval) -> Animation { Animation(SinAnimation(duration: duration))}
}

func modifiedSin(x: Double) -> Double {
    return (sin(Double.pi * (x-0.5))+1)/2
}

// based on https://pypi.org/project/elo/
// https://en.wikipedia.org/wiki/Elo_rating_system
// takes user rating and puzzle rating,
func updateElo(userRating: Double, userKFactor: Double, puzzleRating: Int, correct: Bool) -> Double {
    let score: Double = correct ? 1.0 : 0.0
    let beta = 200
    let f_factor = Double(2 * beta)
    let diff = Double(puzzleRating) - Double(userRating)
    let expectedScore = 1 / (1 + pow(10, diff / f_factor))
    let adjust = score - expectedScore
    return userRating + userKFactor * adjust
}

#Preview {
    GameOverView(startElo: 1700, k: 100, board: BoardLogic(selectedPuzzle: Puzzle(selectedPuzzle: ["1760", "q3k1nr/1pp1nQpp/3p4/1P2p3/4P3/B1PP1b2/B5PP/5K2 b k - 0 17","e8d7 a2e6 d7d8 f7f8", "placeholder_themes"])))
}
