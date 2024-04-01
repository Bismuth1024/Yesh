//
//  WrapperView.swift
//  Yesh
//
//  Created by Manith Kha on 26/12/2022.
//

import SwiftUI

//Put this as an ObservableObject
class CurrentViewWrapper : ObservableObject {
    enum viewEnum {
        case Session
        case OldSession
        case Home
        case History
        case Test
        case Settings
        
        case customDrinks
        case customIngredients
        case BACSettings
    }
    
    @Published var currentView: viewEnum = .Home
}



struct WrapperView: View {
    @StateObject var currentViewObject = CurrentViewWrapper()
    @StateObject var CurrentSession = SessionStore()
    
    var body: some View {
        TabView {
            SessionView(CurrentSession: CurrentSession, past: false)
                .tabItem {
                    Label("Session", systemImage: "wineglass")
                }
            
            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .onAppear {
            CurrentSession.tryLoad()
        }
    }
}
    
struct WrapperView_Previews: PreviewProvider {
    static var previews: some View {
        WrapperView()
            .environmentObject(SessionStore())
    }
}
