//
//  FrontendContentModel+Operations.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 07. 22..
//

import Vapor
import Fluent
import ViperKit

extension ViperModel where Self.IDValue == UUID {
    
    static func joinedFrontendContentQuery(on db: Database, path: String? = nil) -> QueryBuilder<Self> {
        let query = self.query(on: db)
        .join(FrontendContentModel.self, on: \FrontendContentModel.$reference == \Self._$id)
        .filter(FrontendContentModel.self, \.$module == self.Module.name)
        .filter(FrontendContentModel.self, \.$model == self.name)
        //.filter(FrontendContentModel.self, \.$status != .archived)

        if let path = path {
            return query.filter(FrontendContentModel.self, \.$slug == path.safeSlug())
        }
        return query
    }
    
    func contentReference(on db: Database) throws -> EventLoopFuture<FrontendContentModel> {
        FrontendContentModel.query(on: db)
            .filter(\.$reference == self.id!)
            .filter(\.$module == Self.Module.name)
            .filter(\.$model == Self.name)
            .first()
            .unwrap(or: Abort(.notFound))
    }

    func updateContent(on db: Database, _ block: @escaping (FrontendContentModel) -> Void) throws -> EventLoopFuture<Void> {
        try self.contentReference(on: db)
        .flatMap { model  in
            block(model)
            return model.update(on: db)
        }
    }
    
    func publishContent(on db: Database) throws -> EventLoopFuture<Void> {
        try self.updateContent(on: db) { content in
            content.status = .published
        }
    }
    
    func publishAsHomeContent(on db: Database) throws -> EventLoopFuture<Void> {
        try self.updateContent(on: db) { content in
            content.slug = ""
            content.status = .published
        }
    }
}
