//
//  UserAdminController.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 03. 23..
//

import Fluent
import FeatherCore

struct UserAdminController: ViperAdminViewController {

    typealias Module = UserModule
    typealias Model = UserModel
    typealias EditForm = UserEditForm

    
    var listAllowedOrders: [FieldKey] = [
        Model.FieldKeys.email,
    ]

    func search(using qb: QueryBuilder<Model>, for searchTerm: String) {
        qb.filter(\.$email ~~ searchTerm)
    }

    func beforeList(req: Request, queryBuilder: QueryBuilder<Model>) throws -> QueryBuilder<Model> {
        queryBuilder.sort(\Model.$email)
    }
    
    func delete(req: Request) throws -> EventLoopFuture<String> {
        try find(req).flatMap { user in
            UserTokenModel
                .query(on: req.db)
                .filter(\.$user.$id == user.id!)
                .delete()
        }
        .throwingFlatMap { try find(req) }
        .flatMap { item in item.delete(on: req.db)
        .map { item.id!.uuidString } }
    }
}

