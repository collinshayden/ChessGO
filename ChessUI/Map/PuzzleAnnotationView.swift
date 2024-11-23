////
////  PuzzleAnnotationView.swift
////  ChessUI
////
////  Created by Felix Walberg on 10/10/24.
////

import Foundation
import CoreLocation
import SwiftUI
import MapKit
struct PuzzleAnnotationView:View {
    @Binding var showMap: Bool
    @Binding var showChess: Bool
    @Binding var val: Int
    @Binding var puzzle: PuzzleInfo
    @Binding var curPuzzle: Puzzle
    @EnvironmentObject var locationService: LocationService

    // Helper function to calculate distance between user and the puzzle to determine if they
    // are close enough to access it.
    func getDistance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double {
        let xDistance = to.longitude - from.longitude
        let yDistance = to.latitude - from.latitude
        let totalDistance = (pow(xDistance, 2) + pow(yDistance, 2)).squareRoot()
        return totalDistance
    }
    
    var body:some View {
        VStack(){
            Button(action: {
                if let userLoc = locationService.currentLoc {
                    if getDistance(from: userLoc, to:puzzle.finalLoc) <= startDistanceFromUser * 2 {
                        print("close enough!")
                        print("transfering to puzzle xyz...")
                    // Set the state of the puzzle in the MapView to pass to the PuzzleView
                    curPuzzle = puzzle.puzzle
                    withAnimation {
                        showMap.toggle()
                        showChess = true
                    }
                    // This will handle if a puzzle is too far away, user shouldn't go to PuzzleView
                    } else {
                        print("too far!")
                    }
                }
            }) {
                Text("").font(.system(size: 20))
                    .padding()
                    .background(Image(.puzzle).resizable().frame(width:75, height:60))
                    .frame(minWidth: 500)
            }
            // This frame height adjusts the "clickable" area of the annotation on the map
            .buttonStyle(PlainButtonStyle())
            .frame(width:40, height: 40)
            .contentShape(Circle())
                
                
        }.onAppear(){
            // Once the puzzles appear on the map once relative to the user's location we want them to stay static
            if(!puzzle.isSet) {
                if let userLoc = locationService.currentLoc {
                    puzzle.isSet = true
                    puzzle.finalLoc = CLLocationCoordinate2D(latitude: userLoc.latitude + puzzle.locOffset.latitude, longitude: userLoc.longitude + puzzle.locOffset.longitude)
                }
            }
        }
    }
}
