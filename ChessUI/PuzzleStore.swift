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
    var locOffset: CLLocationCoordinate2D
    var finalLoc: CLLocationCoordinate2D
    var puzzle: Puzzle
    var isSet: Bool
    
    init(val: Int, locOffset: CLLocationCoordinate2D) {
        self.val = val
        self.locOffset = locOffset
        self.puzzle = Puzzle()
        self.isSet = false
        self.finalLoc = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    }
}
class PuzzleStore: ObservableObject {
    @Published var allPuzzles: [PuzzleInfo]
    var firebaseSerivce: FireBaseService = FireBaseService()
    init() {
        allPuzzles = []
        generateSimulatedPuzzles()
        Task{
            await callPuzzles()
        }
        
    }
    
    func generateSimulatedPuzzles() {
        print("generating")
        for i in 0...20{
            let long = (Double(Int.random(in: -2...2)) / 1000)
            let lat = (Double(Int.random(in: -2...2)) / 1000)
//            let testPuzzle = PuzzleInfo(val:i,loc:CLLocationCoordinate2D(latitude: lat, longitude: long), puzzle:Puzzle())
            let testPuzzle = PuzzleInfo(val:i,locOffset:CLLocationCoordinate2D(latitude: lat, longitude: long))

            allPuzzles.append(testPuzzle)
        }
    }
    
    func callPuzzles() async {
        for puzzle in allPuzzles {
//             Should be able to generate specific puzzles for each annotation once we get firebase working with my id
            await puzzle.puzzle = Puzzle(selectedPuzzle:firebaseSerivce.getPuzzle(1300,2000))
//            puzzle.puzzle = Puzzle()
        }
    }
}

