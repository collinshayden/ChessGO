//
//  StatsView.swift
//  ChessUI
//
//  Created by Evan Rohan on 10/22/24.
//

//correct incorrect - could make a map for the over time puzzle rating

import SwiftUI
import Charts

struct Elo : Identifiable {
    var id : String = UUID().uuidString
    var elo : Int
    var puzzle : Int
}
struct StatsView : View {
    
    @EnvironmentObject var userService : UserService
    
    var green: CGFloat {
           let total = userService.correct + userService.incorrect
           return total == 0 ? 0.5 : CGFloat(userService.correct) / CGFloat(total)
       }
    
    var EloPoints: [Elo] {
        var points : [Elo] = []
        for i in 0..<userService.elo.count{
            points.append(Elo(elo:userService.elo[i],puzzle:i))
        }
        return points
        
    }
//    var EloPoints: [Elo] = [
//            Elo(elo: 10, puzzle: 1),
//            Elo(elo: 7, puzzle: 2),
//            Elo(elo: 4, puzzle: 3),
//            Elo(elo: 13, puzzle: 4),
//            Elo(elo: 19, puzzle: 5),
//            Elo(elo: 6, puzzle: 6),
//            Elo(elo: 16, puzzle: 7)
//        ]
    
    @Binding var showStats: Bool
    @Binding var showMap: Bool
    
    var body : some View {
        VStack{
            HStack{
                Text("ELO: ")
                Text("\(userService.elo.last ?? 0)")
            }.padding(.bottom, 70)
            Spacer()
            Text("Puzzles Completed: \(userService.correct + userService.incorrect)")
            GeometryReader{ metrics in
                ZStack(alignment: .leading){
                   Rectangle()
                       .fill(Color.red)
                       .frame(width: metrics.size.width, height: 100)
                   Rectangle()
                       .fill(Color.green)
                       .frame(width: metrics.size.width * green, height: 100)
                }
            }
            Text("ELO Graph")
            Chart {
                      ForEach(EloPoints) { elo in
                          LineMark(
                              x: PlottableValue.value("Puzzles Solved", elo.puzzle),
                              y: PlottableValue.value("Rating", elo.elo)
                          ).foregroundStyle(Color.white)
                              .symbol(.circle)
                             
                      }
                 
            }.chartXAxis {
                AxisMarks { value in
                    AxisValueLabel()
                        .foregroundStyle(Color.white) // X-axis numbers color
                }
            }
            .chartYAxis {
                AxisMarks { value in
                    AxisValueLabel()
                        .foregroundStyle(Color.white) // Y-axis numbers color
                }
            }.chartPlotStyle { area in
                area.background(colors.darkGreen.opacity(0.2))
            }
            DefaultButtonView(buttonImage: "xmark", action: { showStats = false ; showMap = true})
        }.padding(20)
            .environment(\.font, .custom("League Spartan", size: 32))
            .foregroundColor(.white)
            .background(LinearGradient(
                gradient: Gradient(colors: [
                    colors.darkGreen,
                    colors.vermontGreen,
                    colors.lightGreen
                ]),
                startPoint: .top,
                endPoint: .bottom
            ))
    }
}

#Preview {
    @State var showStats = true
    @State var showMap = true
    return StatsView(showStats: $showStats, showMap: $showMap).environmentObject(UserService())
}
