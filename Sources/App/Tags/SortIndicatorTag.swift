//
//  SortIndicatorTag.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 06. 04..
//

import Vapor
import Leaf

struct SortIndicatorTag: LeafTag {
    
    static let name = "sortIndicator"

    func render(_ ctx: LeafContext) throws -> LeafData {
        
        guard let key = ctx.parameters.first?.string else {
            throw "invalid \(Self.name) parameters"
        }

        var isDefaultSort = false
        if ctx.parameters.count > 1, let isDefault = ctx.parameters[1].bool {
            isDefaultSort = isDefault
        }

        let isAscendingOrder = (ctx.request?.query["order"] ?? "asc") == "asc"
        let sort: String? = ctx.request?.query["sort"]
        let arrow = isAscendingOrder ? "▴" : "▾"

        if (sort == nil && isDefaultSort) || key == sort {
            return .string("\(arrow)")
        }
        return .nil(.string)
    }
}
