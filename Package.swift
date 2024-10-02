// swift-tools-version:5.9
import Foundation
import PackageDescription

let package = Package(
    name: "Placement",
    platforms: [
        .iOS(.v14),
        .macCatalyst(.v14),
        .tvOS(.v14),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "Placement",
            targets: ["Placement"]
        )
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Placement",
            dependencies: [
            ],
            exclude: ["Placement.docc"]
        )
    ]
)
