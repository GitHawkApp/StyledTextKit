// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "StyledTextKit",
    platforms: [
        .iOS(.v11),
    ],
    products: [
        .library(
            name: "StyledTextKit",
            targets: ["StyledTextKit"]),
    ],
    targets: [
        .target(
            name: "StyledTextKit",
            path: "Source"
        )
    ]
)
