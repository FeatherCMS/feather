//
//  BlogAuthorLinkAdminController.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 03. 23..
//

import FeatherCore

struct BlogAuthorLinkAdminController: ViperAdminViewController {

    typealias Module = BlogModule
    typealias Model = BlogAuthorLinkModel
    typealias EditForm = BlogAuthorLinkEditForm
    
    var idParamKey: String { "linkId" }
    
    var listAllowedOrders: [FieldKey] = [
        Model.FieldKeys.name,
        Model.FieldKeys.url,
        Model.FieldKeys.priority,
    ]

    func beforeList(req: Request, queryBuilder: QueryBuilder<Model>) throws -> QueryBuilder<Model> {
        guard let id = req.parameters.get("id"), let uuid = UUID(uuidString: id) else {
            throw Abort(.badRequest)
        }
        return queryBuilder
            .filter(\.$author.$id == uuid)
            .sort(\Model.$priority, .descending)
    }
}
