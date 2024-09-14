// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "LocationFormatter",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .watchOS(.v9),
        .tvOS(.v16)
    ],
    products: [
        .library(
            name: "LocationFormatter",
            targets: ["LocationFormatter"]),
    ],
    dependencies: [
        .package(url: "https://github.com/designedbyclowns/UTMConversion.git", branch: "15-invalid-coordinate-fix"),
        .package(url: "https://github.com/apple/swift-numerics.git", from: "1.0.0"),
        .package(url: "https://github.com/designedbyclowns/GeoURI.git", branch: "swift-6"),
    ],
    targets: [
        .target(
            name: "LocationFormatter",
            dependencies: [
                .product(name: "UTMConversion", package: "UTMConversion"),
                .product(name: "GeoURI", package: "GeoURI"),
            ],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
        .testTarget(
            name: "LocationFormatterTests",
            dependencies: [
                "LocationFormatter",
                .product(name: "Numerics", package: "swift-numerics"),
            ]
        ),
    ]
)
