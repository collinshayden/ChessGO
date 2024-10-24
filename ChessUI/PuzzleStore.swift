//
//  PuzzleStore.swift
//  ChessUI
//
//  Created by Felix Walberg on 10/23/24.
//

import Foundation
import MapKit

class PuzzleInfo {
    let id: UUID = UUID()
    var val: Int
    var loc: CLLocationCoordinate2D
//    var puzzle: Puzzle
    
    init(val: Int, loc: CLLocationCoordinate2D) {
        self.val = val
        self.loc = loc
//        self.puzzle = puzzle
    }
}
class PuzzleStore: ObservableObject {
    @Published var allPuzzles: [PuzzleInfo]
//    @EnvironmentObject var firebaseService: FireBaseService
    
    init() {
        allPuzzles = []
//        allPuzzles.append(3)
        generateSimulatedPuzzles()
//        Task{
//            await callPuzzles()
//        }
        
    }
    
    func generateSimulatedPuzzles() {
        for i in 0...20{
//            let adjustment = Double(Int.random(in:0...10))
            let long = -122.0089189 + (Double(Int.random(in: -2...2)) / 1000)
            let lat = 37.335855 + (Double(Int.random(in: -2...2)) / 1000)
//            let testPuzzle = PuzzleInfo(val:i,loc:CLLocationCoordinate2D(latitude: lat, longitude: long), puzzle:Puzzle())
            let testPuzzle = PuzzleInfo(val:i,loc:CLLocationCoordinate2D(latitude: lat, longitude: long))

            allPuzzles.append(testPuzzle)
        }
    }
    
//    func callPuzzles() async {
//        for puzzle in allPuzzles {
//            
//        }
//    }
}
