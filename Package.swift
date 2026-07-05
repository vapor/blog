// swift-tools-version:6.2

import PackageDescription

let package = Package(
    name: "Blog",
    platforms: [.macOS(.v13)],
    products: [
        .executable(
            name: "Blog",
            targets: ["Blog"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/brokenhandsio/kiln.git", from: "1.4.1"),
        .package(url: "https://github.com/vapor/design.git", branch: "main"),
    ],
    targets: [
        .executableTarget(
            name: "Blog",
            dependencies: [
                .product(name: "Kiln", package: "kiln"),
                .product(name: "VaporDesignTheme", package: "design"),
            ]
        ),
    ]
)
