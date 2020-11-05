//
//  BlogMigration_v1_0_0.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2019. 12. 17..
//

import Fluent

struct BlogMigration_v1_0_0: Migration {

    func prepare(on db: Database) -> EventLoopFuture<Void> {
        return db.eventLoop.flatten([
            db.schema(BlogCategoryModel.schema)
                .id()
                .field(BlogCategoryModel.FieldKeys.title, .string, .required)
                .field(BlogCategoryModel.FieldKeys.imageKey, .string, .required)
                .field(BlogCategoryModel.FieldKeys.excerpt, .string, .required)
                .field(BlogCategoryModel.FieldKeys.priority, .int, .required)
                .unique(on: BlogCategoryModel.FieldKeys.title)
                .create(),
            
            db.schema(BlogAuthorModel.schema)
                .id()
                .field(BlogAuthorModel.FieldKeys.name, .string, .required)
                .field(BlogAuthorModel.FieldKeys.imageKey, .string, .required)
                .field(BlogAuthorModel.FieldKeys.bio, .string, .required)
                .create(),
            
            db.schema(BlogPostModel.schema)
                .id()
                .field(BlogPostModel.FieldKeys.title, .string, .required)
                .field(BlogPostModel.FieldKeys.imageKey, .string, .required)
                .field(BlogPostModel.FieldKeys.excerpt, .string, .required)
                .field(BlogPostModel.FieldKeys.content, .string, .required)
                .field(BlogPostModel.FieldKeys.categoryId, .uuid, .required)
                .field(BlogPostModel.FieldKeys.authorId, .uuid, .required)
                .foreignKey(BlogPostModel.FieldKeys.categoryId, references: BlogCategoryModel.schema, .id)
                .foreignKey(BlogPostModel.FieldKeys.authorId, references: BlogAuthorModel.schema, .id)
                .create(),
            
            db.schema(BlogAuthorLinkModel.schema)
                .id()
                .field(BlogAuthorLinkModel.FieldKeys.name, .string, .required)
                .field(BlogAuthorLinkModel.FieldKeys.url, .string, .required)
                .field(BlogAuthorLinkModel.FieldKeys.priority, .int, .required)
                .field(BlogAuthorLinkModel.FieldKeys.authorId, .uuid, .required)
                .foreignKey(BlogAuthorLinkModel.FieldKeys.authorId, references: BlogAuthorModel.schema, .id)
                .create(),
        ])
    }
    
    func revert(on db: Database) -> EventLoopFuture<Void> {
        return db.eventLoop.flatten([
            db.schema(BlogPostModel.schema).delete(),
            db.schema(BlogCategoryModel.schema).delete(),
            db.schema(BlogAuthorModel.schema).delete(),
            db.schema(BlogAuthorLinkModel.schema).delete(),
        ])
    }
}

