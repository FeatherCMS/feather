//
//  MenuAdminController.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 11. 15..
//

import Fluent
import FeatherCore

struct MenuItemAdminController: ViperAdminViewController {

    typealias Module = MenuModule
    typealias Model = MenuItemModel
    typealias EditForm = MenuItemEditForm

    var idParamKey: String { "itemId" }
    
    var listAllowedOrders: [FieldKey] = [
        Model.FieldKeys.label,
        Model.FieldKeys.url,
    ]

    func search(using qb: QueryBuilder<Model>, for searchTerm: String) {
        qb.filter(\.$label ~~ searchTerm)
        qb.filter(\.$url ~~ searchTerm)
    }

    func beforeList(req: Request, queryBuilder: QueryBuilder<Model>) throws -> QueryBuilder<Model> {
        guard let id = req.parameters.get("id"), let uuid = UUID(uuidString: id) else {
            throw Abort(.badRequest)
        }
        return queryBuilder
            .filter(\.$menu.$id == uuid)
            .sort(\Model.$priority, .descending)
    }
    
}
