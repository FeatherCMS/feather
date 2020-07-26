//
//  FrontendContentModelMiddleware.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 07. 22..
//

import Vapor
import Fluent
import ViperKit

protocol FrontendContentModelDelegate: ViperModel where Self.IDValue == UUID {
    var slug: String { get }

    func willUpdate(_: FrontendContentModel)
}

struct FrontendContentModelMiddleware<T: FrontendContentModelDelegate>: ModelMiddleware {

    func create(model: T, on db: Database, next: AnyModelResponder) -> EventLoopFuture<Void> {
        next.create(model, on: db)
        .flatMap {
            let content = FrontendContentModel(id: UUID(),
                                               module: Model.Module.name,
                                               model: Model.name,
                                               reference: model.id!,
                                               slug: model.slug)
            model.willUpdate(content)
            return content.create(on: db)
        }
    }
    
    func update(model: T, on db: Database, next: AnyModelResponder) -> EventLoopFuture<Void> {
        next.update(model, on: db)
        .flatMap {
            FrontendContentModel.query(on: db)
                .filter(\.$reference == model.id!)
                .filter(\.$module == Model.Module.name)
                .filter(\.$model == Model.name)
                .first()
        }
        .flatMap { content -> EventLoopFuture<Void> in
            guard let content = content else {
                return db.eventLoop.future()
            }
            model.willUpdate(content)
            return content.update(on: db)
        }
    }

    func delete(model: T, force: Bool, on db: Database, next: AnyModelResponder) -> EventLoopFuture<Void> {
        next.delete(model, force: force, on: db)
        .flatMap {
            FrontendContentModel.query(on: db)
                .filter(\.$reference == model.id!)
                .filter(\.$module == Model.Module.name)
                .filter(\.$model == Model.name)
                .delete()
        }
    }
}
