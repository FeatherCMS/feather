//
//  BlogPostModel+Query.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 11. 06..
//

import FeatherCore

extension BlogPostModel {

    /// query posts for the home page
    static func home(on req: Request) -> EventLoopFuture<[BlogPostModel]> {
        query(on: req.db)
            .join(Metadata.self, on: \BlogPostModel.$id == \Metadata.$reference, method: .inner)
            .filter(Metadata.self, \.$status == .published)
            .filter(Metadata.self, \.$date <= Date())
            .sort(Metadata.self, \.$date, .descending)
            .range(..<17)
            .with(\.$category)
            .all()
    }
    
    /// public post list
    static func find(on req: Request) -> QueryBuilder<BlogPostModel> {
        findMetadata(on: req.db)
            .filter(Metadata.self, \.$status == .published)
            .filter(Metadata.self, \.$date <= Date())
            .sort(Metadata.self, \.$date, .descending)
            .with(\.$category)
    }

    /// find a single post by metadata
    static func findBy(id: UUID, on req: Request) -> EventLoopFuture<BlogPostModel> {
        findMetadata(on: req.db)
            .filter(\.$id == id)
            .with(\.$category)
            .with(\.$author) { $0.with(\.$links) }
            .first()
            .unwrap(or: Abort(.notFound))
    }
    
    /// query posts for the author page
    static func findByAuthor(id: UUID, on req: Request) -> EventLoopFuture<[BlogPostModel]> {
        findMetadata(on: req.db)
            .filter(Metadata.self, \.$status == .published)
            .filter(Metadata.self, \.$date <= Date())
            .filter(\.$author.$id == id)
            .with(\.$category)
            .sort(Metadata.self, \.$date, .descending)
            .all()
    }

    /// query posts for the category page
    static func findByCategory(id: UUID, on req: Request) -> EventLoopFuture<[BlogPostModel]> {
        findMetadata(on: req.db)
            .filter(Metadata.self, \.$status == .published)
            .filter(Metadata.self, \.$date <= Date())
            .filter(\.$category.$id == id)
            .sort(Metadata.self, \.$date, .descending)
            .all()
    }
}


