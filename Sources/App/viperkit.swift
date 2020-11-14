//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 11. 14..
//

import Vapor
import Fluent

protocol ViperInstaller {
    func variables() -> [[String: Any]]
    func createModels(_: Request) -> EventLoopFuture<Void>?
}

extension ViperInstaller {
    func variables() -> [[String: Any]] { [] }
    func createModels(_: Request) -> EventLoopFuture<Void>? { nil }
}
