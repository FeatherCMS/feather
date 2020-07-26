//
//  CountTag.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 06. 04..
//

import Vapor
import Leaf

struct CountTag: LeafTag {
    
    static let name = "count"

    func render(_ ctx: LeafContext) throws -> LeafData {
        guard let items = ctx.parameters.first?.array else {
            throw "invalid \(Self.name) parameters"
        }
        return .int(items.count)
    }
}
