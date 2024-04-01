//
//  SessionStore.swift
//  Yesh
//
//  Created by Manith Kha on 19/10/2023.
//



/*
 A way of representing a session.  Because it is an ObservableObject, we can't make it an optional (which would make it easier when
 there is no current session).  Hence, we change startTime to an optional: if this is nil, then essentially we treat the whole object as nil.
 
 Currently I save sessions to files to record them: as a list of drinks and when.  The BAC calculations are done separately with the DrinkDataSet struct: maybe I will change this in future.
 
 
 
 */

import Foundation

class SessionStore : ObservableObject, Codable {
    @Published var startTime: Date? = nil
    @Published var endTime: Date? = nil
    @Published var drinks: [DrinkWrapper] = []
    
    var duration: Double? {
        if let startTime {
            return endTime?.timeIntervalSince(startTime)
        } else {
            return nil
        }
    }
    
    /*
    init?(fileURL: URL) {
      
    }
     */
    
    /*
    init?() {
        do {
            let file = try FileHandle(forReadingFrom: SessionStore.CurrentSessionURL)

            let loadedSession = try JSONDecoder().decode(SessionStore.self, from: file.availableData)
            drinks = loadedSession.drinks
            startTime = loadedSession.startTime
            endTime = loadedSession.endTime
        } catch let error as NSError {
            if (error.domain == "NSCocoaErrorDomain" && error.code == 4) {
                return nil
            }
            fatalError()
        }
    }
     */
    
    init() {
        
    }
    
    init(startTime: Date) {
        self.startTime = startTime
    }
    
    init(filename: String) {
        loadFromFile(fileURL: sessionLogsURL().appendingPathComponent(filename))
    }
    
    init(fileURL: URL) {
        loadFromFile(fileURL: fileURL)
    }
    
    //A way to wrap drinks: scope for drinking as a shot or over a longer period of time
    struct DrinkWrapper : Hashable, Identifiable, Codable, Equatable {
        var drink: AlcoholicDrink
        var startTime: Date
        var endTime: Date?
        
        //Because this should be unique
        var id : Date {
            startTime
        }
        
        init(drink: AlcoholicDrink, startTime: Date, endTime: Date? = nil) {
            self.drink = drink
            self.startTime = startTime
            self.endTime = endTime
        }
        
        init(drink: AlcoholicDrink, shotAt time: Date) {
            self.drink = drink
            self.startTime = time
            self.endTime = time
        }
        
        func description() -> String {
            var str = drink.name + ", "
            if let endTime = endTime {
                if endTime == startTime {
                    str += DateHelpers.dateToTime(startTime)
                } else {
                    str += DateHelpers.twoDatesRangeString(startTime, endTime)
                }
            } else {
                str += "started at " + DateHelpers.dateToTime(startTime)
            }
            return str
        }
        
        static var sample: DrinkWrapper = DrinkWrapper(drink: .Martini, startTime: Date(), endTime: Date(timeInterval: 100, since: Date()))
    }
    
    //*****Stuff for encoding and decoding - required because published removes automatic implementation*****
    
    enum CodingKeys: CodingKey {
        case startTime, endTime, drinks
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(startTime, forKey: .startTime)
        try container.encode(endTime, forKey: .endTime)
        try container.encode(drinks, forKey: .drinks)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        startTime = try container.decode(Date?.self, forKey: .startTime)
        endTime = try container.decode(Date?.self, forKey: .endTime)
        drinks = try container.decode([DrinkWrapper].self, forKey: .drinks)
    }
    
    //*****Stuff for loading or saving to files
    
    /*The session can be saved in two ways:
     -As the currently running session (e.g. so if the user closes the app without ending the session, it can be restored)
     -As a completed session to be examined later (e.g. weekly totals and so on)
     
     This function gives the URL for the first case
     */
    static var CurrentSessionURL : URL {
        documentsURL().appendingPathComponent("CurrentSession.data")
    }
    
    //The Date Formatter to use for session log file names decoding/encoding
    
    static var FilenameFormatter : DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-HH:mm"
        return formatter
    }
    
    //The URL for saving a completed log
    var completedSessionURL : URL {
        return sessionLogsURL().appendingPathComponent(SessionStore.FilenameFormatter.string(from: startTime!))
    }
    
    //Loading to be revised - maybe change the result's success return type
    func loadFromFile(fileURL: URL, completion: @escaping (Result<SessionStore, Error>) -> Void) {
        do {
            let file = try FileHandle(forReadingFrom: fileURL)

            let loadedSession = try JSONDecoder().decode(SessionStore.self, from: file.availableData)
            drinks = loadedSession.drinks
            startTime = loadedSession.startTime
            endTime = loadedSession.endTime
            completion(.success(loadedSession))
        } catch {
            print(String(describing: error))
            completion(.failure(error))
        }
    }
    
    func loadFromFile(fileURL: URL) {
        loadFromFile(fileURL: fileURL) { result in
            if case .failure(let error) = result {
                fatalError(String(describing: error))
            }
        }
    }
    
    //Defaults for these functions are the currents session file!
    func load(completion: @escaping (Result<SessionStore, Error>) -> Void) {
        //Load from the current session file
        return loadFromFile(fileURL: SessionStore.CurrentSessionURL, completion: completion)
    }
    
    func load() {
        //Load from the current session file
        load { result in
            if case .failure(let error) = result {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    //Try to load the current session
    @discardableResult func tryLoad() -> Bool {
        do {
            let file = try FileHandle(forReadingFrom: SessionStore.CurrentSessionURL)

            let loadedSession = try JSONDecoder().decode(SessionStore.self, from: file.availableData)
            drinks = loadedSession.drinks
            startTime = loadedSession.startTime
            endTime = loadedSession.endTime
            return true
        } catch let error as NSError {
            if (error.domain == "NSCocoaErrorDomain" && error.code == 4) {
                return false
            }
            fatalError(String(describing: error))
        }
    }
    
    //Saving to revise
    
    func saveToFile(fileURL: URL, completion: @escaping (Result<URL, Error>) -> Void) {
        do {
            let JSONData = try rawData()
            try JSONData.write(to: fileURL)
            completion(.success(fileURL))
        } catch {
            completion(.failure(error))
        }
    }
    
    func saveToFile(fileURL: URL) {
        saveToFile(fileURL: fileURL) { result in
            if case .failure(let error) = result {
                fatalError(String(describing: error))
            }
        }
    }
    
    func save(completion: @escaping (Result<URL, Error>) -> Void) {
        return saveToFile(fileURL: completedSessionURL, completion: completion)
    }
    
    func save() {
        save { result in
            if case .failure(let error) = result {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func saveCompletedSession() {
        return saveToFile(fileURL: completedSessionURL)
    }
    
    func saveCurrentSession() {
        return saveToFile(fileURL: SessionStore.CurrentSessionURL)
    }
    
    //Clear the log of the current session (e.g. after it is finished and saved to permanent storage)
    @discardableResult static func removeCurrentSession() -> Bool {
        do {
            try FileManager.default.removeItem(at: CurrentSessionURL)
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    //Basically the optional check nil
    func isValid() -> Bool {
        return !(startTime == nil)
    }
    
    func rawData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func sort() {
        drinks.sort(by: {$0.startTime < $1.startTime})
    }
    
    func latestDrinkTime() -> Date? {
        
        func resultClosure(current: Date?, next: DrinkWrapper) -> Date? {
            if current == nil {return next.endTime}
            if next.endTime == nil {return current}
            return next.endTime! > current! ? next.endTime! : current!

        }
        
        return drinks.reduce(nil, resultClosure)
    }
    
    //Essentially initialising the session
    func begin(startTime: Date) {
        self.startTime = startTime
    }
    
    func clear() {
        startTime = nil
        endTime = nil
        drinks = []
    }
    
    func totalStandards() -> Double {
        return drinks.reduce(0.0, {current, drink in
            current + drink.drink.numStandards()
        })
    }
    
    func totalSugar() -> Double {
        return drinks.reduce(0.0, {current, drink in
            current + drink.drink.totalSugar()
        })
    }
    
    func totalVolume() -> Double {
        return drinks.reduce(0.0, {current, drink in
            current + drink.drink.totalVolume()
        })
    }
    
    //Trims it to 2 hours past the last drink
    func trim() {
        endTime = Date(timeInterval: 7200, since: latestDrinkTime() ?? startTime ?? Date.now)
    }
    
    static var earliestSessionTime: Date? {
        let names = getLogFileNames()
        if names.isEmpty {return nil}
        let startTimes = names.map({FilenameFormatter.date(from: $0)!})
        return startTimes.reduce(Date.distantFuture) {currentVal, newDate in
            return min(currentVal, newDate)
        }
    }
}
