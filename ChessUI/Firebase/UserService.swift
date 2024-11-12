//
//  UserService.swift
//  ChessUI
//
//  Created by Evan Rohan on 10/22/24.
//
import SwiftUI

class UserService : ObservableObject {
    
    @Published var username = ""
    @Published var elo : [Int] = []
    @Published var correct = 0
    @Published var incorrect = 0
    @Published var themes = []
    @Published var k = 0
    
    init(){ }
    
    func updateUser(username : String, elo : [Int], correct : Int, incorrect : Int, themes : [String], k : Int){
        self.username = username
        self.elo = elo
        self.correct = correct
        self.incorrect = incorrect
        self.themes = themes
        self.k = k
    }
}
