//
//  HistoryAllView.swift
//  Yesh
//
//  Created by Manith Kha on 24/1/2024.
//

/*
 I want to have a generic stats view for a long time period (with the usual totals but also stuff like
 total of each spirit and so on pie charts
 And then from there we can look year by year
 and a year view contains year stats as well as month by month
 ....
 etc
 until we have week with session by session and 
 
 
 
 
 
 
 */

import SwiftUI

struct HistoryAllView: View {
    var body: some View {
        
        Button("test") {
            let names = getLogFileNames()
            for name in names {
                let session = SessionStore()
                session.loadFromFile(fileURL: sessionLogsURL().appendingPathComponent(name))
                StatRecords.AllTimeRecords.append(session)
            }
            Settings.saveCodable(StatRecords.AllTimeRecords, key: "allTimeRecords")
            SessionStore.removeCurrentSession()
        }
    }
}

#Preview {
    HistoryAllView()
}
