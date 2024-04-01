//
//  PackageToPods.swift
//  Package2Pods
//
//  Created by Chen Hai Teng on 3/29/24.
//

import Foundation
import ArgumentParser

enum Package2PodError: Error {
    case templateNotExist(String)
    
}

@main
struct PackageToPods: ParsableCommand {
    static let defalutPodspec = "https://github.com/chenhaiteng/swift-package-to-cocoapods-template"
    
    @Option(name:[.long, .short], help: "The repo or file url of the template podspec.")
    var template: String? = nil
    
    var podspecTemplate : String {
        return template ?? PackageToPods.defalutPodspec
    }
    
    private var fm: FileManager {
        FileManager.default
    }
    
    func copyTemplate(into templateDir: URL) throws {
        if podspecTemplate.isRemote {
            gitclone(repo: PackageToPods.defalutPodspec)
        } else if podspecTemplate.isPodspec {
            let fileUrl = URL(filePath: podspecTemplate)
            debugPrint("local file: \(fileUrl.absoluteString)")
            if fm.fileExists(atPath: fileUrl.path(percentEncoded: false)) {
                try fm.createDirectory(at: templateDir, withIntermediateDirectories: true)
                try fm.copyItem(at: fileUrl, to: templateDir.appending(component: fileUrl.lastPathComponent))
            } else {
                throw Package2PodError.templateNotExist("no such file:\(podspecTemplate)")
            }
        } else {
            throw Package2PodError.templateNotExist("\(podspecTemplate) is not a podspec")
        }
    }
    
    func getPodspecTemplate(_ url: URL) throws -> String {
        guard url.isFileURL else {
            throw Package2PodError.templateNotExist("no such file:\(podspecTemplate)")
        }
        return try .init(contentsOf: url, encoding: .utf8)
    }
    
    func readTemplate(in templateDir: URL) throws -> String {
        let urls = try fm.contentsOfDirectory(at: templateDir, includingPropertiesForKeys: nil, options: [])
        
        let podspecUrl = urls.first(where: {$0.isFileURL && $0.pathExtension == "podspec" })
        return try getPodspecTemplate(podspecUrl!)
    }
    
    mutating func run() throws {
        let templateDir = fm.currentDirectoryURL.appending(path: "./template")
        do {
            let spmInfo = try getSPMInfo()
            let gitInfo = getGitInfo()
            
            try copyTemplate(into: templateDir)
            
            let podspecTemplate = try readTemplate(in: templateDir)
            
            let result = createPodspec(podspecTemplate, spmInfo: spmInfo, gitInfo: gitInfo)
            
            let outputURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appending(component: spmInfo.name).appendingPathExtension("podspec")
            try result.write(to: outputURL, atomically: true, encoding: .utf8)
            print("Create podspec \(spmInfo.name).podspec successfully!")
            print("Next step: run 'pod lib lint' to validate the podspec.")
        } catch {
            print("Cannot create podspec!!!")
            print("error: \(error)")
        }

        try fm.removeItem(at: templateDir)
    }
}

