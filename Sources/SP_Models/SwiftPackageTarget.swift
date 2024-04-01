//
//  SwiftPackageTarget.swift
//  Package2Pods
//
//  Created by Chen Hai Teng on 3/31/24.
//

import Foundation

struct SwiftPackageTarget: Decodable {
    struct Dependency : Decodable {
        let name: String
        enum CodingKeys: String, CodingKey {
            case name = "byName"
        }
        
        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if let decodedName = try container.decode([String?].self, forKey: .name).first, let name = decodedName {
                self.name = name
            } else {
                throw DecodingError.valueNotFound(String.self, .init(codingPath:[CodingKeys.name], debugDescription: "cannot get dependency name in target"))
            }
        }
    }

    let dependencies: [SwiftPackageTarget.Dependency]
    let name: String
}
