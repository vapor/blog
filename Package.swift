// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "Blog",
    platforms: [.macOS(.v12)],
    products: [
        .executable(
            name: "Blog",
            targets: ["Blog"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/johnsundell/publish.git", branch: "master"),
        .package(url: "https://github.com/alexito4/ReadingTimePublishPlugin.git", from: "0.3.0"),
        .package(url: "https://github.com/vapor/design.git", branch: "main"),
    ],
    targets: [
        .executableTarget(
            name: "Blog",
            dependencies: [
                .product(name: "Publish", package: "publish"),
                .product(name: "ReadingTimePublishPlugin", package: "ReadingTimePublishPlugin"),
                .product(name: "VaporDesign", package: "design"),
            ]
        ),
    ]
)
