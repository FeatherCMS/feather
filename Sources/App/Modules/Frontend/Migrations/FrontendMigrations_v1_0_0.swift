//
//  FrontendMigration_v1_0_0.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 06. 09..
//

import Vapor
import Fluent

struct FrontendMigration_v1_0_0: Migration {
        
    func prepare(on db: Database) -> EventLoopFuture<Void> {
        db.schema(FrontendContentModel.schema)
            .id()
            .field(FrontendContentModel.FieldKeys.module, .string, .required)
            .field(FrontendContentModel.FieldKeys.model, .string, .required)
            .field(FrontendContentModel.FieldKeys.reference, .uuid, .required)
            .field(FrontendContentModel.FieldKeys.slug, .string, .required)
            .field(FrontendContentModel.FieldKeys.date, .date, .required)
            .field(FrontendContentModel.FieldKeys.status, .string, .required)
            .field(FrontendContentModel.FieldKeys.filters, .array(of: .string), .required)
            .field(FrontendContentModel.FieldKeys.feedItem, .bool, .required)
            .field(FrontendContentModel.FieldKeys.title, .string)
            .field(FrontendContentModel.FieldKeys.excerpt, .string)
            .field(FrontendContentModel.FieldKeys.imageKey, .string)
            .field(FrontendContentModel.FieldKeys.canonicalUrl, .string)
            .unique(on: FrontendContentModel.FieldKeys.slug)
            .unique(on: FrontendContentModel.FieldKeys.module,
                    FrontendContentModel.FieldKeys.model,
                    FrontendContentModel.FieldKeys.reference)
            .create()
    }

    func revert(on db: Database) -> EventLoopFuture<Void> {
        db.schema(FrontendContentModel.schema).delete()
    }
}

