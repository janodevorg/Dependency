// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "Dependency",
    platforms: [
        .iOS(.v16), 
        .macCatalyst(.v16),
        .macOS(.v13),
        .tvOS(.v16)
    ],
    products: [
        .library(name: "Dependency", targets: ["Dependency"])
    ],
    dependencies: [
        .package(url: "git@github.com:apple/swift-docc-plugin.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "Dependency",
            dependencies: [],
            path: "sources/main"
        ),
        .testTarget(
            name: "DependencyTests",
            dependencies: ["Dependency"],
            path: "sources/tests"
        )
    ]
)
