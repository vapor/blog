// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "Blog",
    products: [
        .executable(
            name: "Blog",
            targets: ["Blog"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/johnsundell/publish.git", from: "0.8.0")
    ],
    targets: [
        .target(
            name: "Blog",
            dependencies: [
                .product(name: "Publish", package: "publish")
            ]
        )
    ]
)
