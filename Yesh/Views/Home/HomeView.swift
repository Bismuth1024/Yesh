//
//  HomeView.swift
//  Yesh
//
//  Created by Manith Kha on 28/12/2023.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var currentViewObject : CurrentViewWrapper
    @EnvironmentObject var CurrentSession : SessionStore
    var body: some View {
        VStack {
            Text("Home View")
            Button("new session") {
                CurrentSession.begin(startTime: Date.now)
                CurrentSession.saveCurrentSession()
                currentViewObject.currentView = .Session
            }
            Button("Debug") {
                SessionStore.removeCurrentSession()
            }
            Button("Print logs") {
                do {
                    let filenames = try FileManager.default.contentsOfDirectory(atPath: sessionLogsURL().path())
                    for file in filenames {
                        print(file)
                        let tempSession = SessionStore()
                        let data = try tempSession.rawData()
                        tempSession.loadFromFile(fileURL: sessionLogsURL().appendingPathComponent(file))
                        
                        print("\(MemoryLayout.size(ofValue: data))")
                    }
                } catch {
                    print(error)
                }
            }
            Button("graph") {
                
            }
        }
    }
}

#Preview {
    HomeView()
}
