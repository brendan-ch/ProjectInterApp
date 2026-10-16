// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ProjectInterWidgetsCore",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .tvOS(.v14),
        .watchOS(.v7),
        .visionOS(.v1)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ProjectInterWidgetsCore",
            targets: ["ProjectInterWidgetsCore"]
        ),
    ],
    dependencies: [
        .package(path: "../ProjectInterOperations"),
        .package(path: "../ProjectInterShared"),
        .package(
            url: "https://github.com/apollographql/apollo-ios",
            from: "2.0.0"
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ProjectInterWidgetsCore",
            dependencies: [
                .product(name: "ProjectInterShared", package: "ProjectInterShared"),
                .product(name: "ProjectInterOperations", package: "ProjectInterOperations")
            ],
        ),
        .testTarget(
            name: "ProjectInterWidgetsCoreTests",
            dependencies: [
                "ProjectInterWidgetsCore",
                .product(name: "ApolloTestSupport", package: "apollo-ios"),
            ],
        ),
    ]
)
