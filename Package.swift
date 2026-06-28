// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "SUISideMenu",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "SUISideMenu", targets: ["SUISideMenu"]),
    ],
    targets: [
        .target(
            name: "SUISideMenu",
            path: "Sources/SUISideMenu"
        ),
        .testTarget(
            name: "SUISideMenuTests",
            dependencies: ["SUISideMenu"],
            path: "Tests/SUISideMenuTests"
        ),
    ]
)
