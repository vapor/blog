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
        // The blog runs on Kiln (the same generator as the docs and main site).
        // Released builds use the tagged dependency; for local Kiln development
        // (e.g. unreleased blog features) swap to the path dependency below.
        // .package(url: "https://github.com/brokenhandsio/kiln.git", from: "1.3.0"),
        .package(path: "../../BH/kiln"),
        // Shared Vapor design templates (header/footer/cards), pulled in as a
        // Kiln theme layer. Local path during development; a tagged release once
        // the design package is published.
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
