//
//  YearTag.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 06. 18..
//

import Vapor
import Leaf

struct YearTag: LeafTag {
    
    static let name = "year"

    func render(_ ctx: LeafContext) throws -> LeafData {
        return .int(Calendar(identifier: .gregorian).component(.year, from: Date()))
    }
}

