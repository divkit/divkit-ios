// swift-tools-version:5.5

import PackageDescription

let package = Package(
  name: "DivKit",
  platforms: [
    .iOS(.v11),
  ],
  products: [
    .library(name: "DivKit", targets: ["DivKit"]),
    .library(name: "DivKitExtensions", targets: ["DivKitExtensions"])
  ],
  targets: [
    .target(
      name: "BaseUIPublic",
      dependencies: [
        "BaseTinyPublic",
      ],
      path: "Core/BaseUIPublic"
    ),
    .target(
      name: "BasePublic",
      dependencies: [
        "BaseTinyPublic",
        "BaseUIPublic",
      ],
      path: "Core/BasePublic"
    ),
    .target(
      name: "BaseTinyPublic",
      path: "Core/BaseTinyPublic"
    ),
    .target(
      name: "CommonCorePublic",
      dependencies: [
        "BasePublic",
      ],
      path: "Core/CommonCorePublic"
    ),
    .target(
      name: "NetworkingPublic",
      dependencies: [
        "BasePublic",
      ],
      path: "Core/NetworkingPublic"
    ),
    .target(
      name: "DivKit",
      dependencies: [
        "CommonCorePublic",
        "LayoutKit",
        "NetworkingPublic",
        "Serialization",
      ],
      path: "DivKit",
      exclude: [
        "generator_config.json",
      ]
    ),
    .target(
      name: "DivKitExtensions",
      dependencies: [
        "DivKit",
      ],
      path: "DivKitExtensions"
    ),
    .target(
      name: "LayoutKit",
      dependencies: [
        "CommonCorePublic",
        "LayoutKitInterface",
      ],
      path: "LayoutKit/LayoutKit"
    ),
    .target(
      name: "LayoutKitInterface",
      dependencies: [
        "BasePublic",
      ],
      path: "LayoutKit/Interface"
    ),
    .target(
      name: "Serialization",
      dependencies: [
        "CommonCorePublic",
      ],
      path: "Serialization"
    ),
  ]
)
