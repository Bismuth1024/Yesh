//
//  StatRow.swift
//  Yesh
//
//  Created by Manith Kha on 4/2/2024.
//

import SwiftUI

struct StatRow: View {
    var name = ""
    var thisValue = 0.0
    var recordValue = 0.0
    var format: (Double) -> String = {"\($0)"}
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(name)
            HStack {
                Text("This session")
                Spacer()
                Text("All-time record")
            }
            HStack {
                Text(format(thisValue))
                Spacer()
                Text(format(recordValue))
            }
            ProgressBar(value: thisValue, target: recordValue)
                .frame(height: 20)
        }
    }
}

#Preview {
    StatRow()
}
