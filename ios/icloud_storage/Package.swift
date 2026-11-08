// swift-tools-version: 5.9
import PackageDescription

let package = Package(
  name: "icloud_storage",
  platforms: [.iOS(.v13)],
  products: [
    .library(name: "icloud-storage", targets: ["icloud_storage"])
  ],
  dependencies: [
    .package(name: "FlutterFramework", path: "../FlutterFramework")
  ],
  targets: [
    .target(
      name: "icloud_storage",
      dependencies: [
        .product(name: "FlutterFramework", package: "FlutterFramework")
      ],
      resources: [.process("PrivacyInfo.xcprivacy")]
    )
  ]
)
