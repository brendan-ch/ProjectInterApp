// swift-tools-version:5.9

import PackageDescription

let package = Package(
  name: "ProjectInterOperations",
  platforms: [
    .iOS(.v12),
    .macOS(.v10_14),
    .tvOS(.v12),
    .watchOS(.v5),
  ],
  products: [
    .library(name: "ProjectInterOperations", targets: ["ProjectInterOperations"]),
    .library(name: "ProjectInterTestMocks", targets: ["ProjectInterTestMocks"]),
  ],
  dependencies: [
    .package(url: "https://github.com/apollographql/apollo-ios.git", from: "1.15.3"),
  ],
  targets: [
    .target(
      name: "ProjectInterOperations",
      dependencies: [
        .product(name: "ApolloAPI", package: "apollo-ios"),
      ],
      path: "./Sources"
    ),
    .target(
      name: "ProjectInterTestMocks",
      dependencies: [
        .product(name: "ApolloTestSupport", package: "apollo-ios"),
        .target(name: "ProjectInterOperations"),
      ],
      path: "./ProjectInterTestMocks"
    ),
  ]
)
