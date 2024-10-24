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
    @EnvironmentObject var locationService: LocationService
//    @Binding var id: String
    // TODO: Should have a Puzzle object associated with each of these
    // TODO: Should have a location assigned from some other function that generates random
    // TODO: locations for the puzzles (possibly with banned areas like over water/buildings)
    
    var body:some View {
        VStack(){
//            ZStack(){
                Button(action: {
                    if let userLoc = locationService.currentLoc {
                        if abs(puzzle.loc.latitude - userLoc.latitude) <= 0.001 {
                            print("close!")
                            print("transfering to puzzle xyz...")
                            showMap.toggle()
                            showChess = true
                        } else {
                            print("too far!")
                        }
                        
//                        print("transfering to puzzle xyz...")
//                        showMap.toggle()
//                        showChess = true
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
//            Text("Puzzle \(val)")
//        }
    }
    
    
}


//#Preview {
//    PuzzleAnnotationView(showMap:true)
//
//}

