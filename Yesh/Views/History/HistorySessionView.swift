//
//  HistorySessionView.swift
//  Yesh
//
//  Created by Manith Kha on 24/1/2024.
//

/*
 
 Duration
 Total standards
 Total sugar
 Total volume drunk (any drink)
 Peak BAC
 Total time above 0.05 BAC
 
 
 Want a table of
 
 ""         This session        record
 duration   xxx                 xxx
 peak BAC   xxx                 xxx
 
 etc.
 
 */

import SwiftUI

struct HistorySessionView: View {
    //Because ios only displays one column of table
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    private var isCompact: Bool { horizontalSizeClass == .compact }
    #else
    private let isCompact = false
    #endif
    
    
    
    
    var filename: String = ""
    @StateObject var Session: SessionStore = SessionStore()
    @State var Stats: SummaryStats = SummaryStats()
    @State var Wrappers = [String : TableWrapper]()
    @State var Records: StatRecords = StatRecords()
    
    var body: some View {
        
        VStack {
            StatRow(name: "Total standards", thisValue: Stats.totalStandards, recordValue: Records.maxStandards.value) {val in
                String(format: "%.2f", val)
            }
            StatRow(name: "Total sugar", thisValue: Stats.totalSugar, recordValue: Records.maxSugar.value) {val in
                String(format: "%.2f g", val)
            }
            StatRow(name: "Total volume", thisValue: Stats.totalVolume, recordValue: Records.maxVolume.value) {val in
                String(format: "%.0f mL", val)
            }
            StatRow(name: "Peak BAC (mg%)", thisValue: Stats.peakBAC, recordValue: Records.maxBAC.value) {val in
                String(format: "%.3f", val)
            }
            StatRow(name: "Time above 0.05 BAC", thisValue: Stats.timeAbove005, recordValue: Records.maxTimeAbove.value) {val in
                DateHelpers.secondsTo([.hour, .minute], value: Int(val))
            }
            StatRow(name: "Duration", thisValue: Stats.duration, recordValue: Records.maxDuration.value) {val in
                DateHelpers.secondsTo([.hour, .minute], value: Int(val))
            }
            Spacer()
            HStack {
                Spacer()
                NavigationLink {
                    SessionView(CurrentSession: Session, past: true)
                } label: {
                    HStack {
                        Text("More details")
                        Label("", systemImage: "chevron.right")
                    }
                }
            }
        }
        .padding([.leading, .trailing, .bottom], 20)
        .onAppear {
            Session.loadFromFile(fileURL: sessionLogsURL().appendingPathComponent(filename))
            Stats = SummaryStats(from: Session)
            Wrappers = TableWrapper.wrap(Stats, SummaryStats.Records)
            Records = Settings.loadCodable(key: "allTimeRecords") ?? StatRecords()
        }
    }
}

#Preview {
    HistorySessionView()
}
