//
//  StaticPageAdminController.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 06. 09..
//

import Vapor
import Fluent
import ViperKit

final class StaticPageAdminController: ViperAdminViewController {
    typealias Module = StaticModule
    typealias Model = StaticPageModel
    typealias EditForm = StaticPageEditForm
    
    // MARK: - api

    var listSortable: [FieldKey] {
        [
            Model.FieldKeys.title,
        ]
    }
    
    func search(using qb: QueryBuilder<Model>, for searchTerm: String) {
        qb.filter(\.$title ~~ searchTerm)
    }
    
    func beforeRender(req: Request, form: EditForm) -> EventLoopFuture<Void> {
        var future: EventLoopFuture<Void> = req.eventLoop.future()
        if let id = form.id, let uuid = UUID(uuidString: id) {
            future = FrontendContentModel.query(on: req.db)
                .filter(\.$module == Module.name)
                .filter(\.$model == Model.name)
                .filter(\.$reference == uuid)
                .first()
                .map { form.contentModel = $0?.viewContext }
        }
        return future
    }
    
//    func afterCreate(req: Request, form: EditForm, model: Model) -> EventLoopFuture<Response> {
//        .map {
//            req.redirect(to: req.url.path.replaceLastPath(model.viewIdentifier))
//        }
//    }
}
