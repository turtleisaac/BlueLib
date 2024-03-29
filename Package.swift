// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BlueLib",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "BlueLib",
            targets: ["BlueLib"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "BlueLib",
            dependencies: [],
            path: "./Sources"
//            sources: [
//                "BlueLib/BluetoothHomeDelegate.swift",
//                "BlueLib/BluetoothNode.swift",
//                "BlueLib/BluetoothNodeDelegate.swift",
//            ]
        )
//        .testTarget(
//            name: "BlueLibTests",
//            dependencies: ["BlueLib"]),
    ]
)
