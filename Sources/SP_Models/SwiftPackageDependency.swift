//
//  SwiftPackageDependency.swift
//  Package2Pods
//
//  Created by Chen Hai Teng on 3/31/24.
//

import Foundation

struct SwiftPackageDependency: Decodable {
    
    struct Source: Decodable {
        let id: String
        let location: SwiftPackageDependency.Location
        let requirement: SwiftPackageDependency.Requirement // branch, range, exact
        
        enum CodingKeys: String, CodingKey {
            case id = "identity"
            case location
            case requirement
        }
    }
    
    struct Location: Decodable {
        let remote: URL
        enum CodingKeys: CodingKey {
            case remote
        }
        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let urlInfo = try container.decode([[String:String]].self, forKey: .remote)
            if let info = urlInfo.first, let urlStr = info["urlString"] {
                self.remote = URL(string: urlStr)!
            } else {
                throw DecodingError.valueNotFound(String.self, .init(codingPath:[CodingKeys.remote], debugDescription: "cannot get remote url"))
            }
        }
    }

    enum Requirement: Decodable {
        case branch(String)
        case range(Range<String>)
        case exact(String)
        case revision(String)
        
        enum CodingKeys: CodingKey {
            case branch
            case range
            case exact
            case revision
        }

        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            var allKeys = ArraySlice(container.allKeys)
            guard let onlyKey = allKeys.popFirst(), allKeys.isEmpty else {
                throw DecodingError.typeMismatch(SwiftPackageDependency.Requirement.self, DecodingError.Context.init(codingPath: container.codingPath, debugDescription: "Invalid number of keys found, expected one.", underlyingError: nil))
            }
            switch onlyKey {
            case .branch:
                let requirement = try container.decode([String].self, forKey: onlyKey)
                print("requirement : branch: \(requirement)")
                self = .branch(requirement.first!)
            case .range:
    //            let ranges = try container.decode([Range<String>].self, forKey: onlyKey)
    //            self = .range(ranges.first!)
                let ranges = try container.decode([[String:String]].self, forKey: onlyKey)
                let range = ranges.first!["lowerBound"]!..<ranges.first!["upperBound"]!
                self = .range(range)
            case .exact:
                let requirement = try container.decode([String].self, forKey: onlyKey)
                print("requirement : exact: \(requirement)")
                self = .exact(requirement.first!)
            case .revision:
                let requirement = try container.decode([String].self, forKey: onlyKey)
                print("requirement : revision: \(requirement)")
                self = .revision(requirement.first!)
            }
        }
    }


    let sourceControl: [SwiftPackageDependency.Source]
}
