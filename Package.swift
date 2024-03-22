// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MiVIP",
    defaultLocalization: "en",
    platforms: [.iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "MiVIP",
            targets: ["MiVIPSdk","MiVIPApi","MiVIPLiveness"]
    ],
    targets: [
        .binaryTarget(
            name: "MiVIPSdk",
            path: "SDKs/MiVIPSdk.xcframework"
        ),
        .binaryTarget(
            name: "MiVIPApi",
            path: "SDKs/MiVIPApi.xcframework"
        ),
        .binaryTarget(
            name: "MiVIPLiveness",
            path: "SDKs/MiVIPLiveness.xcframework"
        )
    ]
)
