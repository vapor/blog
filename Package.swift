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
        .package(url: "https://github.com/brokenhandsio/kiln.git", from: "1.7.0"),
        // TEMPORARY (local test): local design checkout for the shared-theme +
        // #designResource migration. Revert to the github/main dep after publish.
        .package(path: "../design"),
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
