//
//  HistoryView.swift
//  Yesh
//
//  Created by Manith Kha on 22/1/2024.
//
/*
 
 Nested structure: You can view all time to see totals for years
 View a year to see totals for months
 View a month to see totals for weeks
 View a week to see totals for days
 View a day to see totals for sessions
 
 But this might really complicate it? You might still want to know e.g. total number of sessions for one year and so on
 
 Revised plan:
 Any time period can generate a display of totals and average on a per session basis
 
 All time: also narrow down to year.
 Year: also narrow down to month
 month to week
 individual sessions
 
 So for each view (all/year/month/week) we need to find the subdivisions (next smaller time period), and calculate summary stats
 for each one.  But the next level of subdivision does not need to be done until we select a smaller time period.
 
 
 
 
 */
import SwiftUI

struct HistoryView: View {
    @State var timePeriod : TimePeriod = .Week
    
    enum TimePeriod: String, CaseIterable {
        case Week, Month, Year, All = "All time"
    }
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Time period", selection: $timePeriod) {
                    ForEach(TimePeriod.allCases, id:\.rawValue) { period in
                        Text(period.rawValue).tag(period)
                    }
                }
                .pickerStyle(.segmented)
                ZStack {
                    HistoryWeekView()
                        .opacity(timePeriod == .Week ? 1.0 : 0.0)
                    HistoryMonthView()
                        .opacity(timePeriod == .Month ? 1.0 : 0.0)
                    HistoryYearView()
                        .opacity(timePeriod == .Year ? 1.0 : 0.0)
                    HistoryAllView()
                        .opacity(timePeriod == .All ? 1.0 : 0.0)
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        }
    }
}

#Preview {
    HistoryView()
}
