//
//  SystemMigration_v1_0_0.swift
//  Feather
//
//  Created by Tibor Bödecs on 2020. 06. 10..
//

import Vapor
import Fluent

struct SystemMigration_v1_0_0: Migration {

    func prepare(on db: Database) -> EventLoopFuture<Void> {
        db.schema(SystemVariableModel.schema)
            .id()
            .field(SystemVariableModel.FieldKeys.key, .string, .required)
            .field(SystemVariableModel.FieldKeys.value, .string)
            .field(SystemVariableModel.FieldKeys.hidden, .bool, .required)
            .field(SystemVariableModel.FieldKeys.notes, .string)
            .unique(on: SystemVariableModel.FieldKeys.key)
            .create()
    }

    func revert(on db: Database) -> EventLoopFuture<Void> {
        db.schema(SystemVariableModel.schema).delete()
    }
}
