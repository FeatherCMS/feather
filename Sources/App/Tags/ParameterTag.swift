//
//  ParameterTag.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 03. 28..
//

import Vapor
import Leaf

struct ParameterTag: LeafTag {
    
    static let name = "param"

    func render(_ ctx: LeafContext) throws -> LeafData {
        guard let key = ctx.parameters.first?.string else {
            throw "invalid \(Self.name) parameters"
        }
        if let value = ctx.request?.parameters.get(key) {
            return .string(value)
        }
        return .nil(.string)
    }
}
