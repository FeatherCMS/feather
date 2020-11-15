//
//  MenuMigration_v1_0_0.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 11. 15..
//

import Vapor
import Fluent

struct MenuMigration_v1_0_0: Migration {
        
    func prepare(on db: Database) -> EventLoopFuture<Void> {
        db.schema(MenuModel.schema)
            .id()
            .field(MenuModel.FieldKeys.handle, .string, .required)
            .field(MenuModel.FieldKeys.name, .string)
            .field(MenuModel.FieldKeys.icon, .int)
            .unique(on: MenuModel.FieldKeys.handle)
            .create()
    }

    func revert(on db: Database) -> EventLoopFuture<Void> {
        db.schema(MenuModel.schema).delete()
    }
}

