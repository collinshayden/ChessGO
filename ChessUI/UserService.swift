//
//  UserService.swift
//  ChessUI
//
//  Created by Evan Rohan on 10/22/24.
//
import SwiftUI

class UserService : ObservableObject {
    
    var firebase = FireBaseService()
    @Published var username = ""
    @Published var elo = 0
    @Published var correct = 0
    @Published var incorrect = 0
    @Published var tactics = []
    
    init()
    {
        Task{
            let info = await firebase.getUser()
            self.username = info.0
            self.elo = info.1
            self.correct = info.2
            self.incorrect = info.3
            self.tactics = info.4
        }
    }
}
