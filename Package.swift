// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "StocksApi",
    platforms: [
        .iOS(.v13), .macOS(.v12), .tvOS(.v13), .watchOS(.v8)
    ],
    products: [
        .library(
            name: "StocksApi",
            targets: ["StocksApi"]),
        .executable(name: "StocksApiExec", targets: ["StocksApiExec"])
    ],
    targets: [
        .target(
            name: "StocksApi"),
        .executableTarget(name: "StocksApiExec",
                         dependencies: ["StocksApi"]),
        .testTarget(
            name: "StocksApiTests",
            dependencies: ["StocksApi"]),
    ]
)
