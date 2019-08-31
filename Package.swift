// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "DeallocationChecker",
    products: [
        .library(name: "DeallocationChecker", targets: ["DeallocationChecker"])
    ],
    targets: [
        .target(name: "DeallocationChecker", dependencies: [], path: "Sources")
    ]
)
