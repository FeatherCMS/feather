//
//  RedirectAdminController.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 03. 26..
//

import Vapor
import Fluent
import ViewKit

final class RedirectAdminController: ViperAdminViewController {

    typealias Module = RedirectModule
    typealias Model = RedirectModel
    typealias EditForm = RedirectEditForm
    
    var listSortable: [FieldKey] {
        [
            Model.FieldKeys.source,
            Model.FieldKeys.destination,
        ]
    }
    
    func search(using qb: QueryBuilder<Model>, for searchTerm: String) {
        qb.filter(\.$source ~~ searchTerm)
        qb.filter(\.$destination ~~ searchTerm)
    }
}
