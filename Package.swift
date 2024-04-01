// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Package2Pods",
    platforms: [.macOS(.v13)],
    products: [.executable(name: "package-to-pods", targets: ["Package2Pods"])],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.3.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "Package2Pods", dependencies: [.product(name: "ArgumentParser", package: "swift-argument-parser"),]),
    ]
)
