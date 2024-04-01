//
//  Data+Ext.swift
//  Package2Pods
//
//  Created by Chen Hai Teng on 3/31/24.
//

import Foundation

extension Data {
    var toUTF8String: String? {
        String(data:self, encoding: .utf8)?.trimmingCharacters(in: CharacterSet.newlines)
    }
}
