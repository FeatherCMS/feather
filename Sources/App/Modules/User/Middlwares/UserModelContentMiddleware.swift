//
//  UserModelContentMiddleware.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 08. 11..
//

import Vapor
import Fluent

/// we use this middleware to ensure that email addresses are always saved as lowercased strings
struct UserModelContentMiddleware: ModelMiddleware {

    /// transform email to lowercase before create an entry
    func create(model: UserModel, on db: Database, next: AnyModelResponder) -> EventLoopFuture<Void> {
        model.email = model.email.lowercased()
        return next.create(model, on: db)
    }

    /// transform email to lowercase before update an entry
    func update(model: UserModel, on db: Database, next: AnyModelResponder) -> EventLoopFuture<Void> {
        model.email = model.email.lowercased()
        return next.update(model, on: db)
    }
}
