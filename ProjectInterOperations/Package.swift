// swift-tools-version:6.1

import PackageDescription

let package = Package(
  name: "ProjectInterOperations",
  platforms: [
    .iOS(.v15),
    .macOS(.v12),
    .tvOS(.v15),
    .watchOS(.v8),
    .visionOS(.v1),
  ],
  products: [
    .library(name: "ProjectInterOperations", targets: ["ProjectInterOperations"]),
    .library(name: "ProjectInterTestMocks", targets: ["ProjectInterTestMocks"]),
  ],
  dependencies: [
    .package(url: "https://github.com/apollographql/apollo-ios", exact: "2.4.0"),
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
  ],
  swiftLanguageModes: [.v6, .v5]
)
