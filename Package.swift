// swift-tools-version:5.9

import PackageDescription

let vgsl = (
  url: "https://github.com/yandex/vgsl.git",
  packageName: "vgsl",
  version: Version("7.3.0")
)

let package = Package(
  name: "DivKit",
  platforms: [
    .iOS(.v13),
  ],
  products: [
    .library(name: "DivKit", targets: ["DivKit"]),
    .library(name: "DivKitExtensions", targets: ["DivKitExtensions"]),
    .library(name: "DivKitMarkdownExtension", targets: ["DivKitMarkdownExtension"]),
    .library(name: "DivKitSVG", targets: ["DivKitSVG"]),
  ],
  dependencies: [
    .package(
      url: vgsl.url,
      from: vgsl.version
    ),
    .package(url: "https://github.com/apple/swift-markdown.git", from: "0.4.0"),
  ],
  targets: [
    .target(
      name: "DivKit",
      dependencies: [
        "LayoutKit",
        .product(name: "VGSL", package: vgsl.packageName),
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
      name: "DivKitMarkdownExtension",
      dependencies: [
        "DivKit",
        "LayoutKit",
        .product(name: "VGSL", package: vgsl.packageName),
        .product(name: "Markdown", package: "swift-markdown"),
      ],
      path: "DivKitMarkdownExtension"
    ),
    .target(
      name: "DivKitSVG",
      dependencies: [
        "DivKit",
        .product(name: "VGSL", package: vgsl.packageName),
      ],
      path: "DivKitSVG"
    ),
    .target(
      name: "LayoutKit",
      dependencies: [
        .product(name: "VGSL", package: vgsl.packageName),
        "LayoutKitInterface",
      ],
      path: "LayoutKit/LayoutKit"
    ),
    .target(
      name: "LayoutKitInterface",
      dependencies: [
        .product(name: "VGSL", package: vgsl.packageName),
      ],
      path: "LayoutKit/Interface"
    ),
    .target(
      name: "Serialization",
      dependencies: [
        .product(name: "VGSL", package: vgsl.packageName),
      ],
      path: "Serialization"
    ),
  ]
)
