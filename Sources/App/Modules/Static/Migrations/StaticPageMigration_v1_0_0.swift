//
//  StaticPageMigration_v1_0_0.swift
//  Feather
//
//  Created by Tibor Bödecs on 2020. 06. 07..
//

import FeatherCore

struct StaticPageMigration_v1_0_0: Migration {
    
    func prepare(on db: Database) -> EventLoopFuture<Void> {
        db.schema(StaticPageModel.schema)
            .id()
            .field(StaticPageModel.FieldKeys.title, .string, .required)
            .field(StaticPageModel.FieldKeys.content, .data)
            .create()
    }

    func revert(on db: Database) -> EventLoopFuture<Void> {
        db.schema(StaticPageModel.schema).delete()
    }
}
