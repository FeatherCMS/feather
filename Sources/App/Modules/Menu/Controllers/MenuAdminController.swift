//
//  MenuAdminController.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 11. 15..
//

import Fluent
import FeatherCore

struct MenuAdminController: ViperAdminViewController {

    typealias Module = MenuModule
    typealias Model = MenuModel
    typealias EditForm = MenuEditForm
    
    var listAllowedOrders: [FieldKey] = [
        Model.FieldKeys.handle,
        Model.FieldKeys.name,
    ]

    func search(using qb: QueryBuilder<Model>, for searchTerm: String) {
        qb.filter(\.$handle ~~ searchTerm)
        qb.filter(\.$name ~~ searchTerm)
    }
}
