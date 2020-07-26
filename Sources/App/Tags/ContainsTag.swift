//
//  ContainsTag.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 07. 18..
//

import Vapor
import Leaf

struct ContainsTag: LeafTag {
    
    static let name = "contains"

    func render(_ ctx: LeafContext) throws -> LeafData {
        guard ctx.parameters.count == 2 else {
            throw "invalid \(Self.name) parameter count"
        }
        guard let needle = ctx.parameters[0].string else {
            throw "invalid \(Self.name) parameters"
        }
        guard let array = ctx.parameters[1].array else {
            throw "invalid \(Self.name) parameters"
        }
        return .bool(array.map(\.string).contains(needle))
    }
}
