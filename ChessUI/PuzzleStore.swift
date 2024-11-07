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
let totalOffsetScalar = 60
let puzzleSpacing = 0.0005

// Stores location of puzzle object on map as well as the actual puzzle associated with it
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

// A container to hold all of the puzzle objects that are displayed on the map
// Takes care of the randomness of generation and spacing of puzzles from user and each other
class PuzzleStore: ObservableObject {
    @Published var allPuzzles: [PuzzleInfo]
    var firebaseSerivce: FireBaseService = FireBaseService()
    init() {
        allPuzzles = []
        generatePuzzles()
        Task{
            await callPuzzles()
        }
        
    }
    
    // Verifies that a puzzle cannot be within puzzleSpacing distance from another puzzle
    func checkInvalidLocationFor(possiblePuzzleLoc:CLLocationCoordinate2D) -> Bool{
        for puzzle in allPuzzles{
            let xDistance = possiblePuzzleLoc.longitude - puzzle.locOffset.longitude
            let yDistance = possiblePuzzleLoc.latitude - puzzle.locOffset.latitude
            let totalDistance = (pow(xDistance, 2) + pow(yDistance, 2)).squareRoot()
            if totalDistance <= puzzleSpacing {
                print("too close")
                return true
            }
        }
        return false
    }
    
    // Fills the allPuzzles array with PuzzleInfo objects
    // Each puzzle object is given a random location that conforms to the restrictions
    // of proximity to user and other puzzles
    func generatePuzzles() {
        for i in 0...numPuzzlesOnMap{
            var long = (Double(Int.random(in: -totalOffsetScalar...totalOffsetScalar)) / longLatScalar)
            var lat = (Double(Int.random(in: -totalOffsetScalar...totalOffsetScalar)) / longLatScalar)
            
            while (pow(long, 2) + pow(lat, 2)).squareRoot() <= startDistanceFromUser || checkInvalidLocationFor(possiblePuzzleLoc: CLLocationCoordinate2D(latitude: lat, longitude: long)){
                long = (Double(Int.random(in: -totalOffsetScalar...totalOffsetScalar)) / longLatScalar)
                lat = (Double(Int.random(in: -totalOffsetScalar...totalOffsetScalar)) / longLatScalar)
            }
            let testPuzzle = PuzzleInfo(val:i,locOffset:CLLocationCoordinate2D(latitude: lat, longitude: long))
            allPuzzles.append(testPuzzle)
        }
    }
    
    // Firebase call to retrieve puzzles that fall within the appropriate elo range of the user
    // These puzzles are then each assigned to a unique puzzle object on the map
    func callPuzzles() async {
        for puzzle in allPuzzles {
//             Should be able to generate specific puzzles for each annotation once we get firebase working with my id
            await puzzle.puzzle = Puzzle(selectedPuzzle:firebaseSerivce.getPuzzle(1300,2000))
//            puzzle.puzzle = Puzzle()
        }
    }
}

