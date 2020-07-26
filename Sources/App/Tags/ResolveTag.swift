//
//  ResolveTag.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 06. 13..
//

import Vapor
import Leaf

struct ResolveTag: LeafTag {
    
    static let name = "resolve"

    func render(_ ctx: LeafContext) throws -> LeafData {
        guard let key = ctx.parameters.first?.string else {
            throw "invalid \(Self.name) parameters"
        }
        if let value: String = ctx.request?.fs.resolve(key: key) {
            return .string(value)
        }
        return .nil(.string)
    }
}
