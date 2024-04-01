//
//  HistoryWeekView.swift
//  Yesh
//
//  Created by Manith Kha on 24/1/2024.
//

import SwiftUI

struct HistoryMonthView: View {
    @State var currentMonthStart: Date = Calendar(identifier: .gregorian).nextDate(after: Date.now, matching: DateHelpers.FirstOfMonth, matchingPolicy: .strict, direction:  .backward)!
    @State var isConfirmingDelete = false
    @State var deleteIndices: IndexSet = []
    @State var sessionsShowing = false
    
    @State var nextMonthStart: Date = Date.now
    
    @State var weeksOfMonth : [Date] = [] //To hold the start dates of each week within this month
    
    var validFilenames : [String] {
        return getLogFileNames().filter({
            (currentMonthStart...nextMonthStart).contains(SessionStore.FilenameFormatter.date(from: $0)!)})
    }
    
    var body: some View {
        VStack {
            Picker("type", selection: $sessionsShowing) {
                Text("Sessions").tag(true)
                Text("Summary").tag(false)
            }
            .pickerStyle(.segmented)
            .padding([.leading, .trailing, .bottom], 5)
            
            HStack {
                Button {
                    incrementMonthStart(-1)
                } label: {
                    Label("", systemImage: "chevron.left")
                }
                Spacer()
                Text("Month starting  ")
                DatePicker("Time", selection: $currentMonthStart, displayedComponents: [.date])
                    .labelsHidden()
                Spacer()
                Button {
                    incrementMonthStart(1)
                } label: {
                    Label("", systemImage: "chevron.right")
                }
                
                
            }
            
            TwoOptionView(isFirstShowing: $sessionsShowing) {
                List {
                    ForEach(weeksOfMonth, id: \.self) {weekStart in
                        let nextWeekStart = DateHelpers.weekAfter(weekStart)
                        let weekSessions = getLogFileNames().filter({
                            (weekStart...nextWeekStart).contains(SessionStore.FilenameFormatter.date(from: $0)!)
                        })
                        let nSessions = weekSessions.count
                        
                        Section {
                            Text(DateHelpers.dateToCalendarDate(weekStart) + " to " + DateHelpers.dateToCalendarDate(nextWeekStart))
                            Text("Sessions: \(nSessions)")
                        } header: {
                            
                        }
                    }
                    .onDelete {offsets in
                        deleteIndices = offsets
                        isConfirmingDelete.toggle()
                    }
                }
                .listStyle(InsetGroupedListStyle())
            } and: {
                StatRecordsView(startTime: $currentMonthStart, endTime: $nextMonthStart)
            }
            .padding([.leading, .trailing], 5)
        }
        .navigationDestination(for: String.self) { str in
            HistorySessionView(filename: str)
        }
        .alert("Delete this session permanently?", isPresented: $isConfirmingDelete) {
            Button(role: .destructive) {
                for idx in deleteIndices {
                    let name = validFilenames[idx]
                    do {
                        try FileManager.default.removeItem(at: sessionLogsURL().appendingPathComponent(name))
                    } catch {
                        fatalError(String(describing: error))
                    }
                }
            } label: {
                Text("Delete Session")
            }
        }
        .onChange(of: currentMonthStart) { _ in
            update()
        }
        .onAppear {
            update()
        }
    }
    
    func update() {
        nextMonthStart = Calendar(identifier: .gregorian).nextDate(after: currentMonthStart, matching: DateHelpers.FirstOfMonth, matchingPolicy: .strict)!
        
        weeksOfMonth = []
        
        var weekToAppend = currentMonthStart
        while weekToAppend <= nextMonthStart {
            weeksOfMonth.append(weekToAppend)
            weekToAppend = DateHelpers.weekAfter(weekToAppend)
        }

    }
    
    func incrementMonthStart(_ nMonths: Int) {
        //Assume -1 or +1, we can fix it later
        
        currentMonthStart = Calendar(identifier: .gregorian).nextDate(after: currentMonthStart, matching: DateHelpers.FirstOfMonth, matchingPolicy: .strict, direction: nMonths < 0 ? .backward : .forward)!
        
    }
    
    
}

#Preview {
    HistoryWeekView()
}
