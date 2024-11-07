//
//  UserService.swift
//  ChessUI
//
//  Created by Evan Rohan on 10/22/24.
//
import SwiftUI

class UserService : ObservableObject {
    
    @Published var username = ""
    @Published var elo: Int = 0
//    @Published var kFactor: Double = 100.0
    @Published var correct = 0
    @Published var incorrect = 0
    @Published var themes = []
    
    init(){ }
    
    func updateUser(username : String, elo : Int, correct : Int, incorrect : Int, themes : [String]){
        self.username = username
        self.elo = elo
//        self.kFactor = kFactor
        self.correct = correct
        self.incorrect = incorrect
        self.themes = themes
        
    }
}
