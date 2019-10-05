// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Hover",
    platforms: [
       .iOS(.v11),
    ],
    products: [
        .library(
            name: "Hover",
            targets: ["Hover"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Hover",
            dependencies: [],
            path: "Hover"),
    ]
)
