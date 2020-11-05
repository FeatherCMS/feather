//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 08. 11..
//

import Vapor
import Fluent

struct UserModelContentMiddleware: ModelMiddleware {

    func create(model: UserModel, on db: Database, next: AnyModelResponder) -> EventLoopFuture<Void> {
        model.email = model.email.lowercased()
        print(model.email)
        return next.create(model, on: db)
    }

    func update(model: UserModel, on db: Database, next: AnyModelResponder) -> EventLoopFuture<Void> {
        model.email = model.email.lowercased()
        print(model.email)
        return next.update(model, on: db)
    }
}
