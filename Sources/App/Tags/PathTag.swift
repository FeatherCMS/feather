//
//  PathTag.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 06. 04..
//

import Vapor
import Leaf

struct PathTag: LeafTag {
    
    static let name = "path"

    func render(_ ctx: LeafContext) throws -> LeafData {
        if let value = ctx.request?.url.path {
            return .string(value)
        }
        return .nil(.string)
    }
}

