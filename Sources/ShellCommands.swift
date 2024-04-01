//
//  ShellCommands.swift
//  Package2Pods
//
//  Created by Chen Hai Teng on 4/1/24.
//

import Foundation

func getSPMInfo() throws -> SwiftPackageInfo  {
    if let outputData = try shellWithOutput("swift", "package", "dump-package") {
        let decoder = JSONDecoder()
        return try decoder.decode(SwiftPackageInfo.self, from: outputData)
    } else {
        fatalError("cannot parse swift package")
    }
}

func getGitInfo() -> [String:String] {
    var result = [String:String]()
    if let data = try? shellWithOutput("git", "remote", "get-url", "origin"), let source = data.toUTF8String {
        debugPrint("get source: \(source)")
        // Convert git to https
        debugPrint(source.toHttps ?? "cannot convert" )
        
        result[PodReplaceKeys.git_remote] = source.toHttps ?? "## import git remote failed, please input it manually."
    }
    if let data = try? shellWithOutput("git", "config", "user.name"), let name = data.toUTF8String {
        debugPrint("git user: \(name)")
        result[PodReplaceKeys.user_name] = name
    }
    if let data = try? shellWithOutput("git", "config", "user.email"), let email = data.toUTF8String {
        debugPrint("git user email: \(email)")
        result[PodReplaceKeys.user_email] = email
    }
    
    if let data = try? shellWithOutput("git", "describe", "--tags", "--abbrev=0"), let tag = data.toUTF8String {
        debugPrint("tag: \(tag)")
        result[GitInfoKeys.tag] = tag
    }
    return result
}

func createPodspec(_ template: String, spmInfo: SwiftPackageInfo, gitInfo: [String: String]) -> String {
    var modified = template
    modified.replace(PodReplaceKeys.pod_name, with: spmInfo.name)
    
    // import git info
    for (key, value) in gitInfo {
        modified.replace(key, with: value)
    }
    
    // import swift package info
    // insert swift version
    if let insertPostion = modified.insertingPosition(of: InsertSpecs.swift_version) {
        modified.insert(contentsOf: "\n  \(spmInfo.podSwiftVersion)", at: insertPostion)
    }
    
    // insert platforms
    if let insertPosition = modified.insertingPosition(of: InsertSpecs.platforms) {
        modified.insert(contentsOf: "\(spmInfo.podPlatforms)", at: insertPosition)
    }
    
    // insert dependencies
    if let insertPosition = modified.insertingPosition(of: InsertSpecs.dependencies) {
        modified.insert(contentsOf: "\(spmInfo.podDependencies)", at: insertPosition)
    }
    return modified
}

func gitclone(repo: String) {
    do {
        try shell("git", "clone", repo, "./template")
    } catch {
        debugPrint("clone failed: \(error)")
    }
}

