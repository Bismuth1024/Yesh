//
//  StatRecordsView.swift
//  Yesh
//
//  Created by Manith Kha on 7/2/2024.
//

import SwiftUI

struct StatRecordsView: View {
    @Binding var startTime: Date
    @Binding var endTime: Date
    @State var Stats: StatRecords = StatRecords()
    @State var displayMethod : displayMethodEnum = .total
    
    
    enum displayMethodEnum : Hashable, CaseIterable {
        case total, average, best
    }
    
    var body: some View {
        VStack {
            Text("Stats for the period " + DateHelpers.dateToCalendarDate(Stats.startTime) + " to " + DateHelpers.dateToCalendarDate(Stats.endTime))
            
            Form {
                Section {
                    
                    switch (displayMethod) {
                    case displayMethodEnum.total:
                        TotalView(Stats: $Stats)
                    case displayMethodEnum.average:
                        AverageView(Stats: $Stats)
                    case displayMethodEnum.best:
                        BestView(Stats: $Stats)
                    }
                    
                } header: {
                    HStack {
                        Picker("display method", selection: $displayMethod) {
                            Text("Average").tag(displayMethodEnum.average)
                            Text("Best").tag(displayMethodEnum.best)
                            Text("Total").tag(displayMethodEnum.total)
                        }
                        Text("values")
                    }
                }
            }
            
            StatRecordsChartView(Stats: $Stats)

        }
        
        
        
        .onChange(of: startTime) {
            update()
        }
        .onChange(of: endTime) {
            update()
        }
    }
    
    func update() {
        Stats = StatRecords(startTime: startTime, endTime: endTime)
        Stats.autoCalculate()
    }
    
    struct TotalView: View {
        @Binding var Stats: StatRecords
        var body: some View {
            HStack {
                Text("Number of sessions:")
                Spacer()
                Text(String(format: "%d", Stats.nSessions))
            }
            
            HStack {
                Text("Standard drinks:")
                Spacer()
                Text(String(format: "%.2f", Stats.totalStandards))
            }
            
            HStack {
                Text("Sugar (g):")
                Spacer()
                Text(String(format: "%.2f", Stats.totalSugar))
            }
            
            HStack {
                Text("Volume drunk (mL):")
                Spacer()
                Text(String(format: "%.0f", Stats.totalVolume))
            }
            
            HStack {
                Text("Time above 0.05 BAC:")
                Spacer()
                Text(DateHelpers.secondsTo([.hour, .minute], value: Int(Stats.totalTimeAbove)))
            }
            
            HStack {
                Text("Duration:")
                Spacer()
                Text(DateHelpers.secondsTo([.hour, .minute], value: Int(Stats.totalDuration)))
            }
        }
    }
    
    struct BestView: View {
        @Binding var Stats: StatRecords
        var body: some View {
            if Stats.nSessions == 0 {
                Text("No sessions")
            } else {
                
                VStack {
                    let stat = Stats.maxStandards
                    HStack {
                        Text("Standard drinks:")
                        Spacer()
                        Text(String(format: "%.2f", stat.value))
                    }
                    
                    Text("Set during session at " + DateHelpers.dateToDescription(stat.time))
                }
                
                VStack {
                    let stat = Stats.maxBAC
                    HStack {
                        Text("BAC (mg%):")
                        Spacer()
                        Text(String(format: "%.3f", stat.value))
                    }
                    
                    Text("Set during session at " + DateHelpers.dateToDescription(stat.time))
                }
                
                VStack {
                    let stat = Stats.maxSugar
                    HStack {
                        Text("Sugar (g):")
                        Spacer()
                        Text(String(format: "%.2f", stat.value))
                    }
                    
                    Text("Set during session at " + DateHelpers.dateToDescription(stat.time))
                }
                
                VStack {
                    let stat = Stats.maxVolume
                    HStack {
                        Text("Volume drunk (mL):")
                        Spacer()
                        Text(String(format: "%.0f", stat.value))
                    }
                    
                    Text("Set during session at " + DateHelpers.dateToDescription(stat.time))
                }
                
                VStack {
                    let stat = Stats.maxTimeAbove
                    HStack {
                        Text("Time above 0.05 BAC:")
                        Spacer()
                        Text(DateHelpers.secondsTo([.hour, .minute], value: Int(stat.value)))
                    }
                    
                    Text("Set during session at " + DateHelpers.dateToDescription(stat.time))
                }
                
                VStack {
                    let stat = Stats.maxDuration
                    HStack {
                        Text("Duration:")
                        Spacer()
                        Text(DateHelpers.secondsTo([.hour, .minute], value: Int(stat.value)))
                    }
                    
                    Text("Set during session at " + DateHelpers.dateToDescription(stat.time))
                }
            }
        }
    }
    
    struct AverageView: View {
        @Binding var Stats: StatRecords
        var body: some View {
            
            if Stats.nSessions == 0 {
                Text("No sessions")
            } else {
                HStack {
                    Text("Number of sessions:")
                    Spacer()
                    Text(String(format: "%d", Stats.nSessions))
                }
                
                HStack {
                    Text("Standard drinks:")
                    Spacer()
                    Text(String(format: "%.2f", Stats.averageStandards))
                }
                
                HStack {
                    Text("Peak BAC (mg%)):")
                    Spacer()
                    Text(String(format: "%.3f", Stats.averagePeakBAC))
                }
                
                HStack {
                    Text("Sugar (g):")
                    Spacer()
                    Text(String(format: "%.2f", Stats.averageSugar))
                }
                
                HStack {
                    Text("Volume drunk (mL):")
                    Spacer()
                    Text(String(format: "%.0f", Stats.averageVolume))
                }
                
                HStack {
                    Text("Time above 0.05 BAC:")
                    Spacer()
                    Text(DateHelpers.secondsTo([.hour, .minute], value: Int(Stats.averageTimeAbove)))
                }
                
                HStack {
                    Text("Duration:")
                    Spacer()
                    Text(DateHelpers.secondsTo([.hour, .minute], value: Int(Stats.averageDuration)))
                }
            }
        }
    }
}

#Preview {
    StatRecordsView(startTime: .constant(.distantPast), endTime: .constant(.distantFuture))
}
