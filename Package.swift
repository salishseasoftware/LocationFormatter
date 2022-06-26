// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "LocationFormatter",
    platforms: [.iOS(.v13), .macOS(.v10_13)],
    products: [
        .library(
            name: "LocationFormatter",
            targets: ["LocationFormatter"]),
    ],
    dependencies: [
        .package(url: "https://github.com/wtw-software/UTMConversion", from: "1.4.0"),
        .package(url: "https://github.com/apple/swift-docc-plugin.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "LocationFormatter",
            dependencies: [.product(name: "UTMConversion", package: "UTMConversion")]),
        .testTarget(
            name: "LocationFormatterTests",
            dependencies: ["LocationFormatter"]),
    ]
)
