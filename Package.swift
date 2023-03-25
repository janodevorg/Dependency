// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "Dependency",
    platforms: [
        .iOS(.v14), 
        .macCatalyst(.v14), 
        .macOS(.v12),
        .tvOS(.v14)
    ],
    products: [
        .library(name: "Dependency", type: .static, targets: ["Dependency"]),
        .library(name: "DependencyDynamic", type: .dynamic, targets: ["Dependency"])
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
