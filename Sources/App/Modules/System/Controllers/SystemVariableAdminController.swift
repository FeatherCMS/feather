//
//  SystemVariableAdminController.swift
//  Feather
//
//  Created by Tibor Bödecs on 2020. 06. 10..
//

import FeatherCore
import Fluent

struct SystemVariableAdminController: ViperAdminViewController {

    typealias Module = SystemModule
    typealias Model = SystemVariableModel
    typealias EditForm = SystemVariableEditForm

    var listAllowedOrders: [FieldKey] = [
        Model.FieldKeys.key,
        Model.FieldKeys.value,
    ]

    func search(using qb: QueryBuilder<Model>, for searchTerm: String) {
        qb.filter(\.$key ~~ searchTerm)
        qb.filter(\.$value ~~ searchTerm)
    }
    
    func beforeList(req: Request, queryBuilder: QueryBuilder<Model>) throws -> QueryBuilder<Model> {
        queryBuilder
            .filter(\.$hidden == false)
            .sort(\Model.$key)
    }
}
