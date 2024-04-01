//
//  SwiftPackageInfo.swift
//  Package2Pods
//
//  Created by Chen Hai Teng on 3/31/24.
//

import Foundation

let supportedPlatform = [
    "ios" : "ios",
    "macos": "osx"
]

struct SwiftPackageInfo: Decodable, CustomDebugStringConvertible {
    
    struct SwiftVersion: Decodable {
        let version: String
        enum CodingKeys: String, CodingKey {
            case version = "_version"
        }
    }
    
    struct Platform: Decodable {
        let name: String
        let version: String
        
        enum CodingKeys: String, CodingKey {
            case name = "platformName"
            case version
        }
    }

    let name: String
    let platforms: [SwiftPackageInfo.Platform]
    let toolsVersion: SwiftPackageInfo.SwiftVersion
    let dependencies: [SwiftPackageDependency]
    let targets: [SwiftPackageTarget]
    
    enum CodingKeys: CodingKey {
        case name
        case platforms
        case toolsVersion
        case dependencies
        case targets
    }
    
    var debugDescription: String {
        "[swift package: \(name)] swift version: \(toolsVersion)\n\(platforms)\n\(dependencies)"
    }
}

// Convert to podspec
extension SwiftPackageInfo {
    var podPlatforms: String {
        var result: String = ""
        for platform in platforms where supportedPlatform.keys.contains(platform.name) {
            if let name = supportedPlatform[platform.name], !name.isEmpty {
                result.append("\n")
                result.append("  s.platform = :\(name), '\(platform.version)'\n")
                result.append("  s.\(name).deployment_target = '\(platform.version)'")
            }
        }
        return result
    }
    
    var podSwiftVersion: String {
        "s.swift_version  = '\(toolsVersion.version)'"
    }
    
    var podDependencies: String {
        var result: String = ""
        
        var dependency_list = [String]()
        if let target = targets.first(where: { $0.name == name }) {
            dependency_list = target.dependencies.reduce(into: [String](), { partialResult, d in
                partialResult.append(d.name)
            })
        }
        for dependency in dependency_list {
            result.append("\n")
            result.append("  s.dependency  '\(dependency)'")
            if let dependencySetting = dependencies.first(where: { d in
                d.sourceControl.first?.id.caseInsensitiveCompare(dependency) == .orderedSame
            }), let setting = dependencySetting.sourceControl.first {
                result.append(", ")
                switch setting.requirement {
                case .range(let range):
                    result.append("'~> \(range.lowerBound)'")
                default:
                    result.append("'\(setting.requirement) is not supported in podspec, please setup it manually.'")
                }
            }
            
        }
        return result
    }
}
