//
//  FileManager+Ext.swift
//  Package2Pods
//
//  Created by Chen Hai Teng on 4/1/24.
//

import Foundation

extension FileManager {
    var currentDirectoryURL: URL {
        URL(filePath: self.currentDirectoryPath)
    }
}
