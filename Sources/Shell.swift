//
//  Shell.swift
//  Package2Pods
//
//  Created by Chen Hai Teng on 3/31/24.
//

import Foundation
import os

@discardableResult
func shellWithOutput(_ app: String, _ args: String...) throws -> Data? {
    let task = Process()
    let output = Pipe()
    task.executableURL = URL(fileURLWithPath: "/usr/bin/\(app)")
    task.arguments = args
    task.standardOutput = output
    try task.run()
    task.waitUntilExit()
    if 0 == task.terminationStatus {
        return output.fileHandleForReading.readDataToEndOfFile()
    }
    return nil
}

@discardableResult
func shell(_ app: String, _ args: String...) throws -> Int32 {
    let task = Process()
    task.executableURL = URL(fileURLWithPath: "/usr/bin/\(app)")
    task.arguments = args
    try task.run()
    task.waitUntilExit()
    return task.terminationStatus
}

