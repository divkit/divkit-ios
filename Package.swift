// swift-tools-version:5.9

import PackageDescription

let vgsl = (
  url: "https://github.com/yandex/vgsl.git",
  packageName: "vgsl",
  version: Version("5.1.0")
)

let package = Package(
  name: "DivKit",
  platforms: [
    .iOS(.v13),
  ],
  products: [
    .library(name: "DivKit", targets: ["DivKit"]),
    .library(name: "DivKitExtensions", targets: ["DivKitExtensions"]),
  ],
  dependencies: [
    .package(
      url: vgsl.url,
      from: vgsl.version
    ),
  ],
  targets: [
    .target(
      name: "DivKit",
      dependencies: [
        "LayoutKit",
        .product(name: "CommonCorePublic", package: vgsl.packageName),
        .product(name: "NetworkingPublic", package: vgsl.packageName),
        "Serialization",
      ],
      path: "DivKit"
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
        .product(name: "NetworkingPublic", package: vgsl.packageName),
        .product(name: "CommonCorePublic", package: vgsl.packageName),
        "LayoutKitInterface",
      ],
      path: "LayoutKit/LayoutKit"
    ),
    .target(
      name: "LayoutKitInterface",
      dependencies: [
        .product(name: "BasePublic", package: vgsl.packageName),
      ],
      path: "LayoutKit/Interface"
    ),
    .target(
      name: "Serialization",
      dependencies: [
        .product(name: "CommonCorePublic", package: vgsl.packageName),
      ],
      path: "Serialization"
    ),
  ]
)
