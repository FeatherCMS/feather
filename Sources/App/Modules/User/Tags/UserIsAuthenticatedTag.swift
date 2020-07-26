//
//  UserIsAuthenticatedTag.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 07. 05..
//

import Vapor
import Leaf
import ViperKit

struct UserIsAuthenticatedTag: ViperLeafTag {
    
    static let name = "userIsAuthenticated"

    func render(_ ctx: LeafContext) throws -> LeafData {
        if let value = ctx.request?.auth.has(UserModel.self) {
            return .bool(value)
        }
        return .bool(false)
    }
}
