//
//  PermalinkTag.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 03. 30..
//

import Vapor
import Leaf

struct PermalinkTag: LeafTag {
    
    static let name = "permalink"

    func render(_ ctx: LeafContext) throws -> LeafData {
        var absPath = Application.baseUrl
        if let path = ctx.parameters.first?.string {
            absPath += path.safePath()
        }
        else if let path = ctx.request?.url.path {
            absPath += path
        }
        return .string(absPath)
    }
}

