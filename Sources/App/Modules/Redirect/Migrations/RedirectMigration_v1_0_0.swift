//
//  RedirectMigration_v1_0_0.swift
//  FeatherCMS
//
//  Created by Tibor Bödecs on 2020. 05. 30..
//

import Vapor
import Fluent

struct RedirectMigration_v1_0_0: Migration {
        
    func prepare(on db: Database) -> EventLoopFuture<Void> {
        db.schema(RedirectModel.schema)
            .id()
            .field(RedirectModel.FieldKeys.source, .string, .required)
            .field(RedirectModel.FieldKeys.destination, .string, .required)
            .field(RedirectModel.FieldKeys.statusCode, .int, .required)
            .unique(on: RedirectModel.FieldKeys.source)
            .create()
    }

    func revert(on db: Database) -> EventLoopFuture<Void> {
        db.schema(RedirectModel.schema).delete()
    }
}

