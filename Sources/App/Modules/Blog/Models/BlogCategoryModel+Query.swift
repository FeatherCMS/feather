//
//  BlogCategoryModel+Query.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 11. 06..
//

import FeatherCore

extension BlogCategoryModel {

    static func findBy(id: UUID, on req: Request) -> EventLoopFuture<BlogCategoryModel> {
        find(id, on: req.db).unwrap(or: Abort(.notFound))
    }

    static func findPublished(on req: Request) -> EventLoopFuture<[BlogCategoryModel]> {
        findMetadata(on: req.db)
            .filter(Metadata.self, \.$status == .published)
            .all()
    }
}
