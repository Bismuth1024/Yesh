//
//  GraphView.swift
//  Yesh
//
//  Created by Manith Kha on 12/1/2024.
//

import SwiftUI
import Charts

struct GraphView: View {
    @ObservedObject var CurrentSession: SessionStore //So that we can actually access the session
    @State var dataSet : DrinkDataSet = DrinkDataSet()
    var horizontalArray: [Date] {
        [dataSet.startTime, dataSet.endTime]
    }
    var shouldShowDrivingLevel : Bool {
        dataSet.maxBAC() > 0.04
    }
    
    
    var body: some View {
        VStack(spacing: 20) {
            Chart {
                ForEach(Array(dataSet.times.enumerated()), id: \.offset) { index, element in
                    LineMark(
                        x: .value("t", element),
                        y: .value("Standards", dataSet.alc_in[index])
                    )
                    .foregroundStyle(by: .value("Value", "Cumulative standards"))
                    
                    
                    LineMark(
                        x: .value("t", element),
                        y: .value("BAC", dataSet.scaled_alc_blood[index])
                    )
                    .foregroundStyle(by: .value("Value", "BAC (mg %)"))
                    .interpolationMethod(.catmullRom)
                }
                
                if shouldShowDrivingLevel {
                    ForEach(Array(horizontalArray.enumerated()), id: \.offset) {index, element in
                        LineMark(
                            x: .value("t", element),
                            y: .value("BAC", 0.05 * dataSet.scaleFactor())
                        )
                        .foregroundStyle(by: .value("Value", "Legal driving level"))
                        .lineStyle(StrokeStyle(dash: [5, 5]))
                    }
                }
                
                 
            }
                        
            .chartForegroundStyleScale([
                "Cumulative standards": .purple,
                "BAC (mg %)": .teal,
                "Legal driving level": .red
            ])
            
            .chartXAxis {
                AxisMarks(position: .bottom, values: dataSet.getXTicks()) { value in
                    AxisGridLine(centered: true, stroke: StrokeStyle(lineWidth: value.index % 2 == 0 ? 2 : 0.5, dash: [2]))
                    if value.index % 2 == 0 {
                        AxisValueLabel {
                            Text(DateHelpers.dateToTime24(value.as(Date.self)!))
                        }
                    }
                }
            }
            
            .chartYAxis {
                AxisMarks(position: .leading, values: dataSet.getStandardsTicks()) { value in
                    AxisTick()
                    AxisGridLine()
                    AxisValueLabel {
                        if value.index % 2 == 0 {
                            Text(String(format: "%.2f", value.as(Double.self)!))
                        }
                    }
                }
                
                 AxisMarks(position: .trailing, values: dataSet.getStandardsTicks()) { value in
                     AxisTick()
                     AxisGridLine()
                     AxisValueLabel {
                         if value.index % 2 == 0 {
                             Text(String(format: "%.3f", value.as(Double.self)! / dataSet.scaleFactor()))
                         }
                     }
                 }
            }
            
            .padding([.leading, .trailing], 0)
        }
        .onAppear {
            update()
        }
        .onChange(of: CurrentSession.drinks) {_ in
            update()
        }
    }
    
    func update() {
        
        /*
         
        let session = SessionStore(startTime: Date())
        session.endTime = Date(timeInterval: 3600, since: session.startTime!)
        session.drinks.append(SessionStore.DrinkWrapper(drink: AlcoholicDrink.Negroni, startTime: Date(timeInterval: 300, since: session.startTime!), endTime: Date(timeInterval: 600, since: session.startTime!)))
        session.drinks.append(SessionStore.DrinkWrapper(drink: AlcoholicDrink.VodkaLemonade, shotAt: Date(timeInterval: 1200, since: session.startTime!)))
         */
        dataSet = DrinkDataSet(from: CurrentSession)
        let indices = getCrossingIndices(dataSet.alc_blood, value: 0.05)

    }
}

#Preview {
    GraphView(CurrentSession: SessionStore())
}
