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
    // TODO: Should have a Puzzle object associated with each of these
    // TODO: Should have a location assigned from some other function that generates random
    // TODO: locations for the puzzles (possibly with banned areas like over water/buildings)
    
    var body:some View {
        VStack(){
//            ZStack(){
                Button(action: {
                    if let userLoc = locationService.currentLoc {
                        // This will actually use the location once we decide how far away puzzles can be accessed from
//                        if abs(puzzle.loc.latitude - userLoc.latitude) <= 0.1 {
                            print("close!")
                            print("transfering to puzzle xyz...")
                        // Set the state of the puzzle in the MapView to pass to the PuzzleView
                        curPuzzle = puzzle.puzzle
                            showMap.toggle()
                            showChess = true
                        // This will handle if a puzzle is too far away
//                        } else {
//                            print("too far!")
//                        }
                    }
                }) {
                    Text("").font(.system(size: 20))
                        .padding()
                        .background(Circle().fill(Color.blue).frame(height:100))
                        .frame(minWidth: 500)
                }
                // This frame height adjusts the "clickable" area of the annotation on the map
                .buttonStyle(PlainButtonStyle())
                .frame(width:40, height: 40)
                .contentShape(Circle())
                
                
            }
    }
    
    
}


//#Preview {
//    PuzzleAnnotationView(showMap:true)
//
//}


