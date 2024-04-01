//
//  HistoryYearView.swift
//  Yesh
//
//  Created by Manith Kha on 24/1/2024.
//

import SwiftUI

struct HistoryYearView: View {
    @State var sessionsShowing = true
    var body: some View {
        Picker("type", selection: $sessionsShowing) {
            Text("Sessions").tag(true)
            Text("Summary").tag(false)
        }
        .pickerStyle(.segmented)
        .padding([.leading, .trailing, .bottom], 5)
        
        TwoOptionView(isFirstShowing: $sessionsShowing) {
            Text("do")
        } and: {
            VStack {
                Text("YEAR")
                
            }
        }
    }
}

#Preview {
    HistoryYearView()
}
