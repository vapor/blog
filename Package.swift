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
        .package(url: "https://github.com/brokenhandsio/kiln.git", from: "1.3.0"),
        // .package(path: "../../BH/kiln"),
    ],
    targets: [
        .executableTarget(
            name: "Blog",
            dependencies: [
                .product(name: "Kiln", package: "kiln"),
            ]
        ),
    ]
)
