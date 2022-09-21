// swift-tools-version:5.7
import Foundation
import PackageDescription

let package = Package(
    name: "Placement",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "Placement",
            type: .dynamic,
            targets: ["Placement"]
        )
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Placement",
            dependencies: [
            ]
        )
    ]
)
