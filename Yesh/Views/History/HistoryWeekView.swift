//
//  HistoryWeekView.swift
//  Yesh
//
//  Created by Manith Kha on 24/1/2024.
//

import SwiftUI

struct HistoryWeekView: View {
    @State var currentWeekStart: Date = Calendar(identifier: .gregorian).nextDate(after: Date.now, matching: DateHelpers.FirstOfWeek, matchingPolicy: .strict, direction:  .backward)!
    @State var isConfirmingDelete = false
    @State var deleteIndices: IndexSet = []
    @State var sessionsShowing = false
    
    @State var nextWeekStart: Date = Date.now
    
    @State var daysOfWeek : [Date] = []
    
    var validFilenames : [String] {
        return getLogFileNames().filter({
            (currentWeekStart...nextWeekStart).contains(SessionStore.FilenameFormatter.date(from: $0)!)})
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
                    incrementWeekStart(-1)
                } label: {
                    Label("", systemImage: "chevron.left")
                }
                Spacer()
                Text("Week starting  ")
                DatePicker("Time", selection: $currentWeekStart, displayedComponents: [.date])
                    .labelsHidden()
                Spacer()
                Button {
                    incrementWeekStart(1)
                } label: {
                    Label("", systemImage: "chevron.right")
                }
                
                
            }
            
            TwoOptionView(isFirstShowing: $sessionsShowing) {
                List {
                    ForEach(daysOfWeek, id: \.self) {weekday in
                        Section(header: Text(DateHelpers.dateToWeekday(weekday) + "(" + DateHelpers.dateToCalendarDate(weekday) + ")")) {
                            let dayFilenames = validFilenames.filter({
                                let sessionDate = SessionStore.FilenameFormatter.date(from: $0)!
                                return DateHelpers.isSameDay(sessionDate, weekday)})
                                if dayFilenames.isEmpty {
                                    Text("No sessions")
                                } else {
                                    ForEach(dayFilenames, id: \.self) {name in
                                        let date = SessionStore.FilenameFormatter.date(from: name)!
                                        ColouredNavigationLink(DateHelpers.dateToTime(date), value: name)
                                    }
                                }
                        }
                    }
                    .onDelete {offsets in
                        deleteIndices = offsets
                        isConfirmingDelete.toggle()
                    }
                }
                .listStyle(InsetGroupedListStyle())
            } and: {
                StatRecordsView(startTime: $currentWeekStart, endTime: $nextWeekStart)
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
        .onChange(of: currentWeekStart) { _ in
            update()
        }
        .onAppear {
            update()
        }
    }
    
    func update() {
        nextWeekStart = DateHelpers.weekAfter(currentWeekStart)
        daysOfWeek = Array(repeating: Date.now, count: 7)
        var idx = 6
        
        Calendar(identifier: .gregorian).enumerateDates(startingAfter: nextWeekStart, matching: DateComponents(hour: 0), matchingPolicy: .strict, direction: .backward) {result,exactMatch,stop in
            if let result {
                if result < currentWeekStart {
                    stop = true
                    return
                }
                daysOfWeek[idx] = result
                idx -= 1
            }
        }
    }
    
    func incrementWeekStart(_ nWeeks: Int) {
        //Assume -1 or +1, we can fix it later
        
        currentWeekStart = Calendar(identifier: .gregorian).nextDate(after: currentWeekStart, matching: DateHelpers.FirstOfWeek, matchingPolicy: .strict, direction: nWeeks < 0 ? .backward : .forward)!
        
    }
    
    
}

#Preview {
    HistoryWeekView()
}
