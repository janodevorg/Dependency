// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "Dependency",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "Dependency", type: .dynamic, targets: ["Dependency"]),
        .library(name: "DependencyStatic", type: .static, targets: ["Dependency"])
    ],
    dependencies: [
        .package(url: "git@github.com:apple/swift-docc-plugin.git", branch: "main"),
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
