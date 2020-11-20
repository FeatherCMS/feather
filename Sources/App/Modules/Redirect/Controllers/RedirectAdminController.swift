//
//  RedirectAdminController.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 03. 26..
//

import Fluent
import FeatherCore

struct RedirectAdminController: ViperAdminViewController {

    typealias Module = RedirectModule
    typealias Model = RedirectModel
    typealias EditForm = RedirectEditForm
    
    var listAllowedOrders: [FieldKey] = [
        Model.FieldKeys.source,
        Model.FieldKeys.destination,
        Model.FieldKeys.statusCode,
    ]

    func search(using qb: QueryBuilder<Model>, for searchTerm: String) {
        qb.filter(\.$source ~~ searchTerm)
        qb.filter(\.$destination ~~ searchTerm)
    }
}
