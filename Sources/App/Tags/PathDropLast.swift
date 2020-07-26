//
//  PathDropLastTag.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 06. 04..
//

import Vapor
import Leaf

struct PathDropLastTag: LeafTag {
    
    static let name = "pathDropLast"

    func render(_ ctx: LeafContext) throws -> LeafData {
        var n = 1
        if let number = ctx.parameters.first?.int {
            n = max(n, number)
        }
        if let value = ctx.request?.url.path {
            let path = value.split(separator: "/").dropLast(n).joined(separator: "/")
            return .string("/" + path + "/")
        }
        return .nil(.string)
    }
}

