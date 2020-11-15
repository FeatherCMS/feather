//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 11. 14..
//

import Vapor
import Fluent
import ViperKit

public protocol ViperInstaller {
    func variables() -> [[String: Any]]
    func createModels(_: Request) -> EventLoopFuture<Void>?
}

public extension ViperInstaller {
    func variables() -> [[String: Any]] { [] }
    func createModels(_: Request) -> EventLoopFuture<Void>? { nil }
}

public extension ViperModule {

    static func sample(asset name: String) -> String {
        let path = Application.Paths.base + "Sources/App/Modules/\(Self.name)/Assets/sample/\(name)"
        do {
            return try String(contentsOf: URL(fileURLWithPath: path), encoding: .utf8)
        }
        catch {
            fatalError("Invalid sample: \(error.localizedDescription)")
        }
    }
}
