//
//  MenuMigration_v1_0_0.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 11. 15..
//

import FeatherCore

struct MenuMigration_v1_0_0: Migration {
        
    func prepare(on db: Database) -> EventLoopFuture<Void> {
        db.eventLoop.flatten([
            db.schema(MenuModel.schema)
                .id()
                .field(MenuModel.FieldKeys.handle, .string, .required)
                .field(MenuModel.FieldKeys.name, .string)
                .field(MenuModel.FieldKeys.icon, .int)
                .unique(on: MenuModel.FieldKeys.handle)
                .create(),
            db.schema(MenuItemModel.schema)
                .id()
                .field(MenuItemModel.FieldKeys.icon, .string)
                .field(MenuItemModel.FieldKeys.label, .string, .required)
                .field(MenuItemModel.FieldKeys.url, .string, .required)
                .field(MenuItemModel.FieldKeys.priority, .int, .required)
                .field(MenuItemModel.FieldKeys.targetBlank, .bool, .required)
                .field(MenuItemModel.FieldKeys.menuId, .uuid, .required)
                .foreignKey(MenuItemModel.FieldKeys.menuId, references: MenuModel.schema, .id)
                .create()
        ])
    }

    func revert(on db: Database) -> EventLoopFuture<Void> {
        db.eventLoop.flatten([
            db.schema(MenuItemModel.schema).delete(),
            db.schema(MenuModel.schema).delete(),
        ])
        
    }
}

