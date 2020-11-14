//
//  StaticPageAdminController.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 06. 09..
//

import Fluent
import FeatherCore

struct StaticPageAdminController: ViperAdminViewController {
    
    typealias Module = StaticModule
    typealias Model = StaticPageModel
    typealias EditForm = StaticPageEditForm
    
    var listOrderBy: [FieldKey] {
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
            future = findMetadata(on: req.db, uuid: uuid).map { form.metadata = $0 }
        }
        return future
    }
}
