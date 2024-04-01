//
//  Helpers.swift
//  Yesh
//
//  Created by Manith Kha on 19/10/2023.
//

import Foundation

func documentsURL() -> URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
}

func sessionLogsURL() -> URL {
    return documentsURL().appendingPathComponent("logs/")
}
