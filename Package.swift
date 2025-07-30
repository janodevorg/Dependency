// swift-tools-version:6.1
import PackageDescription

let package = Package(
    name: "Dependency",
    platforms: [
        .iOS(.v18), 
        .macCatalyst(.v18),
        .macOS(.v15),
        .tvOS(.v18)
    ],
    products: [
        .library(name: "Dependency", targets: ["Dependency"])
    ],
    dependencies: [
        .package(url: "git@github.com:apple/swift-docc-plugin.git", from: "1.4.3")
    ],
    targets: [
        .target(
            name: "Dependency",
            dependencies: [],
            path: "Sources/Main"
        ),
        .testTarget(
            name: "DependencyTests",
            dependencies: ["Dependency"],
            path: "Sources/Tests"
        )
    ]
)
