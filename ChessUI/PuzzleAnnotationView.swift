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
    // TODO: Should have a Puzzle object associated with each of these
    // TODO: Should have a location assigned from some other function that generates random
    // TODO: locations for the puzzles (possibly with banned areas like over water/buildings)
    
    var body:some View {
        ZStack(){
            Button(action: {
                print("transfering to puzzle xyz...")
                showMap.toggle()
                showChess = true
            }) {
                Text("Puzzle XYZ").font(.system(size: 20))
                    .padding()
                    .background(Circle().fill(Color.blue).frame(height:300))
                    .frame(minWidth: 500)
            }
            // This frame height adjusts the "clickable" area of the annotation on the map
            .buttonStyle(PlainButtonStyle()).frame(height: 150)
            
        }
    }
    
    
}


//#Preview {
//    PuzzleAnnotationView(showMap:true)
//
//}

