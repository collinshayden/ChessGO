//
//  GameOverView.swift
//  ChessUI
//
//  Created by James Birmingham on 11/4/24.
//

import SwiftUI

struct GameOverView: View {
    @EnvironmentObject var user: UserService
    @EnvironmentObject var fireBaseService: FireBaseService
    @ObservedObject var logic: BoardLogic
    @State var displayElo: Int = 0
    @State var finished = false
    @State var newElo: Int = 0
    
    init (board: BoardLogic) {
        logic = board
    }
    
    var body: some View {
        VStack(spacing: 6) {
            Text("Good Job! ")
                .opacity({finished ? 1 : 0}())
            Text("Old rating: \(Int(user.elo.last!))")
                .opacity({finished ? 1 : 0}())
            
            HStack {
                Text("New rating:")
                Text("\(displayElo)")
                    .numericAnimation(number: Double(displayElo))
                    .onAppear {
                        withAnimation(.sinAnimation(duration: log10(Double(abs(newElo-user.elo.last!)))+3)) {
                            displayElo = newElo
                        } completion: {
                            withAnimation(.sinAnimation(duration: 2)) {
                                finished = true
                            }
                        }
                    }
            }
            RoundedButtonView(buttonText: "Reset", action: { logic.reset()})
            .opacity({finished ? 1 : 0}())
            
        
        }
        .padding(10)
        .environment(\.font, .custom("League Spartan", size: 32))
        .foregroundColor(Color.white)
        .onAppear {
            newElo = updateElo(userRating: Double(user.elo.last!), userKFactor: Double(user.k), puzzleRating: Int(logic.puzzle.rating), correct: !logic.puzzleFailed)
            displayElo = user.elo.last!
            var eloHistory = user.elo
            eloHistory.append(newElo)
            Task {
                await fireBaseService.updateUserAccount(
                    username: user.username,
                    elo: eloHistory,
                    correct: !logic.puzzleFailed ? user.correct + 1 : user.correct,
                    incorrect: logic.puzzleFailed ? user.incorrect + 1 : user.incorrect,
                    themes: ["placeholder"],
                    k: get_k_factor(puzzlesCompleted: user.correct))
            }
        }
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
func updateElo(userRating: Double, userKFactor: Double, puzzleRating: Int, correct: Bool) -> Int {
    let score: Double = correct ? 1.0 : 0.0
    let beta = 200
    let f_factor = Double(2 * beta)
    let diff = Double(puzzleRating) - Double(userRating)
    let expectedScore = 1 / (1 + pow(10, diff / f_factor))
    let adjust = score - expectedScore
    return Int(userRating + userKFactor * adjust)
}

func get_k_factor(puzzlesCompleted: Int) -> Int {
    if puzzlesCompleted < 2 {
        return 400
    }
    else if puzzlesCompleted < 5 {
        return 200
    }
    else if puzzlesCompleted < 10 {
        return 150
    }
    else {
        return 100
    }
}

#Preview {
    GameOverView(board: BoardLogic(selectedPuzzle: Puzzle())).environmentObject(UserService())
}
