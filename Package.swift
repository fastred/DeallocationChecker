// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "DeallocationChecker",
    products: [
        .library(name: "DeallocationChecker", targets: ["DeallocationChecker-iOS"])
    ],
    targets: [
        .target(name: "DeallocationChecker-iOS", dependencies: [], path: "Sources")
    ]
)
