// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "DeallocationChecker",
    platforms: [
        .iOS(.v9),
        .tvOS(.v9)
    ],
    products: [
        .library(name: "DeallocationChecker", targets: ["DeallocationChecker"])
    ],
    targets: [
        .target(name: "DeallocationChecker", dependencies: [], path: "Sources")
    ]
)
