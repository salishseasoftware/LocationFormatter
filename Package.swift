// swift-tools-version: 5.5

import PackageDescription

let package = Package(
    name: "LocationFormatter",
    platforms: [.iOS(.v12), .macOS(.v10_13)],
    products: [
        .library(
            name: "LocationFormatter",
            targets: ["LocationFormatter"]),
    ],
    dependencies: [
        .package(url: "https://github.com/wtw-software/UTMConversion", from: "1.4.0"),
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

#if swift(>=5.6)
// Add the documentation compiler plugin if possible
package.dependencies.append(
  .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0")
)
#endif
