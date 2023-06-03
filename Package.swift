// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "middleware-server-example",
    platforms: [
        .macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6)
        ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .executable(
            name: "middleware-server-example",
            targets: ["middleware-server-example"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.52.0"),
        .package(url: "https://github.com/apple/swift-nio-extras.git", from: "1.0.0"),
        .package(url: "https://github.com/swift-server/swift-service-lifecycle", from: "2.0.0-alpha.1"),
        .package(url: "https://github.com/apple/swift-distributed-tracing.git", from: "1.0.0-beta"),
        .package(url: "https://github.com/tachyonics/swift-middleware", branch: "poc_3"),
    ],
    targets: [
        .target(
            name: "ExampleAsyncHTTP1Server", dependencies: [
                .product(name: "Logging", package: "swift-log"),
                .product(name: "NIO", package: "swift-nio"),
                .product(name: "NIOHTTP1", package: "swift-nio"),
                .product(name: "NIOExtras", package: "swift-nio-extras"),
                .product(name: "NIOFoundationCompat", package: "swift-nio"),
                .product(name: "ServiceLifecycle", package: "swift-service-lifecycle"),
                .product(name: "Tracing", package: "swift-distributed-tracing"),
                .product(name: "SwiftMiddleware", package: "swift-middleware"),
            ]),
        .executableTarget(
            name: "middleware-server-example", dependencies: [
                .target(name: "ExampleAsyncHTTP1Server"),
            ]),
    ],
    swiftLanguageVersions: [.v5]
)
