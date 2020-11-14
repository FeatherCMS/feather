//
//  UserMigration_v1_0_0.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 02. 20..
//

import Vapor
import Fluent

struct UserMigration_v1_0_0: Migration {
    
    func prepare(on db: Database) -> EventLoopFuture<Void> {
        db.eventLoop.flatten([
            db.schema(UserModel.schema)
                .id()
                .field(UserModel.FieldKeys.email, .string, .required)
                .field(UserModel.FieldKeys.password, .string, .required)
                .unique(on: UserModel.FieldKeys.email)
                .create(),
            db.schema(UserTokenModel.schema)
                .id()
                .field(UserTokenModel.FieldKeys.value, .string, .required)
                .field(UserTokenModel.FieldKeys.userId, .uuid, .required)
                .foreignKey(UserTokenModel.FieldKeys.userId, references: UserModel.schema, .id)
                .unique(on: UserTokenModel.FieldKeys.value)
                .create(),
        ])
    }
    
    func revert(on db: Database) -> EventLoopFuture<Void> {
        db.eventLoop.flatten([
            db.schema(UserModel.schema).delete(),
            db.schema(UserTokenModel.schema).delete(),
        ])
    }
}

