//
//  PuzzleStore.swift
//  ChessUI
//
//  Created by Felix Walberg on 10/23/24.
//

import Foundation
import MapKit

let startDistanceFromUser = 0.0005
let numPuzzlesOnMap = 100
let longLatScalar = 10000.0

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
        for i in 0...numPuzzlesOnMap{
            var long = (Double(Int.random(in: -20...20)) / longLatScalar)
            var lat = (Double(Int.random(in: -20...20)) / longLatScalar)
            
            while (pow(long, 2) + pow(lat, 2)).squareRoot() <= startDistanceFromUser{
                long = (Double(Int.random(in: -20...20)) / longLatScalar)
                lat = (Double(Int.random(in: -20...20)) / longLatScalar)
            }
            
            let testPuzzle = PuzzleInfo(val:i,locOffset:CLLocationCoordinate2D(latitude: lat, longitude: long))

            allPuzzles.append(testPuzzle)
        }
    }
    
    func callPuzzles() async {
        for puzzle in allPuzzles {
//             Should be able to generate specific puzzles for each annotation once we get firebase working with my id
//            await puzzle.puzzle = Puzzle(selectedPuzzle:firebaseSerivce.getPuzzle(800,2000))
            puzzle.puzzle = Puzzle()
        }
    }
}

