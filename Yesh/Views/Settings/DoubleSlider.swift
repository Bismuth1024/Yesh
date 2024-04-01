//
//  DoubleSlider.swift
//  Yesh
//
//  Created by Manith Kha on 17/1/2024.
//

import SwiftUI

struct DoubleSlider: View {
    var name: String = ""
    @Binding var value: Double
    var min: Double
    var max: Double
    var step: Double
    var format: String = "%.2f"
    var scaleFunc: (Double) -> Double = {$0} //in case you want to display different units
    
    var body: some View {
        VStack {
            HStack {
                Text(name)
                
                Spacer()
                
                Text(String(format: format, scaleFunc(value)))
            }
            
            Slider(value: $value, in: min...max, step: step) {
                Text("")
            } minimumValueLabel: {
                Text(String(format: format, scaleFunc(min)))
            } maximumValueLabel: {
                Text(String(format: format, scaleFunc(max)))
            }
        }
    }
}

#Preview {
    DoubleSlider(name: "test", value: .constant(50), min: 1, max: 100, step: 1)
}
