//
//  SystemVariableTag.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 06. 17..
//

import Vapor
import Leaf
import ViperKit

struct SystemVariableTag: ViperLeafTag {
    
    static let name = "systemVariable"

    func render(_ ctx: LeafContext) throws -> LeafData {
        guard let key = ctx.parameters.first?.string else {
            throw "invalid \(Self.name) parameters"
        }
        if let value = ctx.request?.variables.get(key) {
            return .string(value)
        }
        return .nil(.string)
    }
}
