//
//  QueryTag.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 06. 03..
//

import Vapor
import Leaf

struct QueryTag: LeafTag {
    
    static let name = "query"

    func render(_ ctx: LeafContext) throws -> LeafData {
        guard let key = ctx.parameters.first?.string else {
            throw "invalid \(Self.name) parameters"
        }
        if let value: String = ctx.request?.query[key] {
            return .string(value)
        }
        return .nil(.string)
    }
}
