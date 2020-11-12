//
//  BlogPostModel+Query.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 11. 06..
//

import FeatherCore

extension BlogPostModel {

    static func home(on req: Request) -> EventLoopFuture<[BlogPostModel]> {
        query(on: req.db)
            .join(Metadata.self, on: \BlogPostModel.$id == \Metadata.$reference, method: .inner)
            .filter(Metadata.self, \.$status == .published)
            .sort(Metadata.self, \.$date, .descending)
            .range(..<17)
            .with(\.$category)
            .all()
    }

    static func findBy(id: UUID, on req: Request) -> EventLoopFuture<BlogPostModel> {
        findMetadata(on: req.db)
            .filter(\.$id == id)
            .with(\.$category)
            .with(\.$author) { $0.with(\.$links) }
            .first()
            .unwrap(or: Abort(.notFound))
    }
    
    static func findByAuthor(id: UUID, on req: Request) -> EventLoopFuture<[BlogPostModel]> {
        findMetadata(on: req.db)
            .filter(\.$author.$id == id)
            .with(\.$category)
            .all()
    }

    static func findByCategory(id: UUID, on req: Request) -> EventLoopFuture<[BlogPostModel]> {
        findMetadata(on: req.db)
            .filter(\.$category.$id == id)
            .all()
    }
}


