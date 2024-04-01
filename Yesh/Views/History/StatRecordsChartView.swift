//
//  StatRecordsChartView.swift
//  Yesh
//
//  Created by Manith Kha on 11/3/2024.
//

import SwiftUI
import Charts

struct StatRecordsChartView: View {
    @Binding var Stats: StatRecords
    @State var isShowingPopover: Bool = false
    var body: some View {
        VStack {
            Button("test") {
                isShowingPopover.toggle()
            }
            Chart {
                let sortedIngredients = Stats.IngredientsStandardsDictionary.sorted {a, b in
                    a.value < b.value
                }
                ForEach(sortedIngredients, id: \.key) {pair in
                    SectorMark(angle: .value("standards", pair.value))
                        .foregroundStyle(by: .value("ingredient", pair.key))
                        
                }
            }
            .chartOverlay { proxy in
                GeometryReader { geometry in
                    Rectangle().fill(.clear).contentShape(Rectangle())
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    // Convert the gesture location to the coordinate space of the plot area.
                                    let origin = geometry[proxy.plotFrame!].origin
                                    let location = CGPoint(
                                        x: value.location.x - origin.x,
                                        y: value.location.y - origin.y
                                    )
                                    let angle = proxy.angle(at: location)
                                    let val  = proxy.value(atAngle: angle, as: Double.self)!
                                    if angle.radians == val {print("??")}
                                    print("val: \(val)")
                                }
                        )
                }
            }
        }
    }
}

#Preview {
    StatRecordsChartView(Stats: .constant(StatRecords()))
}
