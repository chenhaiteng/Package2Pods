//
//  String+Ext.swift
//  Package2Pods
//
//  Created by Chen Hai Teng on 3/31/24.
//

import Foundation

extension String {
    var isRemote : Bool {
        (hasPrefix("https://") || hasPrefix("http://")) ||
        (hasSuffix(".git") && contains("@"))
    }
    
    var isPodspec: Bool {
        hasSuffix(".podspec")
    }
    
    func firstMatch(_ pattern: String) -> [String] {
        if #available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *) {
            if let regex = try? Regex(pattern) {
                if let match = firstMatch(of:regex) {
                    return match.output.compactMap {
                        return ($0.substring != nil) ? String($0.substring!) : nil
                    }
                }
            }
        } else {
            let nsString = self as NSString
            if let match = try? NSRegularExpression(pattern: pattern, options: []).firstMatch(in: self, range: NSMakeRange(0, nsString.length)) {
                var matchedResult = [String]()
                for i in 0..<match.numberOfRanges {
                    matchedResult.append( nsString.substring(with:match.range(at: i)))
                }
                return matchedResult
            }
        }
        return []
    }
    
    var toHttps: String? {
        guard !hasPrefix("https://") else {
            return self
        }
        if hasPrefix("git@") {
            let matches  = firstMatch(":([^:/]+)/")
            if let owner = matches.last {
                let server = String(prefix(upTo: firstIndex(of: ":")!))
                let project = split(separator: "/").last!
                return "https://\(server)/\(owner)/\(project)"
            }
            return nil
        } else {
            debugPrint("cannot convert to https scheme")
            return nil
        }
    }
    
    func insertingPosition(of spec: String) -> String.Index? {
        range(of:"s.\(spec):begin")?.upperBound
    }
}
