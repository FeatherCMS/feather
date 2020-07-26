//
//  IsDebugTag.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 06. 18..
//

import Vapor
import Leaf

struct IsDebugTag: LeafTag {
    
    static let name = "isDebug"

    func render(_ ctx: LeafContext) throws -> LeafData {
        if let app = ctx.application {
            return .bool(!app.environment.isRelease && app.environment != .production)
        }
        return .nil(.bool)
    }
}

