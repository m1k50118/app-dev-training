//
//  Package.swift
//  Scrumdinger
//
//  Created by 佐藤真 on 2023/01/05.
//

// swift-tools-version:5.7
import Foundation
import PackageDescription

let package = Package(
    name: "Scrumdinger",
    dependencies: [
        .package(url: "https://github.com/apple/swift-format", .branch("master"))
    ]
)

