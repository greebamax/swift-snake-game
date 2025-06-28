// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-snake-game",
    dependencies: [
        .package(url: "https://github.com/STREGAsGate/Raylib.git", branch: "master")
    ],
    targets: [
        .executableTarget(
            name: "swift-snake-game",
            dependencies: ["Raylib"],
        )
    ]
)
