//
//  viper.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 07. 02..
//

import Vapor
import Fluent
import ViperKit
import ViewKit

extension ViperModel where IDValue == UUID {
    var viewIdentifier: String { self.id!.uuidString }
}

extension ViperAdminViewController {
    var listView: String { "\(Module.name.capitalized)/Admin/\(Model.name.capitalized)/List" }
    var editView: String { "\(Module.name.capitalized)/Admin/\(Model.name.capitalized)/Edit" }
    
    func afterCreate(req: Request, form: EditForm, model: Model) -> EventLoopFuture<Response> {
        req.eventLoop.makeSucceededFuture(req.redirect(to: req.url.path.replaceLastPath(model.viewIdentifier)))
    }
}

protocol ViperAdminViewController: AdminViewController where Model: ViperModel {
    associatedtype Module: ViperModule
    
    var listSortKey: String { get }
    var listOrderKey: String { get }
    var listSearchKey: String { get }
    var listLimitKey: String { get }
    var listPageKey: String { get }

    var listSortable: [FieldKey] { get }
    var listLimit: Int { get }
    var listOrder: CustomOrder { get }
    
    func search(using qb: QueryBuilder<Model>, for searchTerm: String)
}

extension ViperAdminViewController {

    var listSortKey: String { "sort" }
    var listOrderKey: String { "order" }
    var listSearchKey: String { "search" }
    var listLimitKey: String { "limit" }
    var listPageKey: String { "page" }
    
    var listSortable: [FieldKey] { [] }
    var listLimit: Int { 10 }
    var listOrder: CustomOrder { .asc }

    func search(using qb: QueryBuilder<Model>, for searchTerm: String) {}

    func listView(req: Request) throws -> EventLoopFuture<View> {
        let sort: String? = req.query[self.listSortKey]
        var order = self.listOrder
        if let i: String = req.query[self.listOrderKey], let o = CustomOrder(rawValue: i) {
            order = o
        }
        let search: String? = req.query[self.listSearchKey]
        let limit: Int = req.query[self.listLimitKey] ?? self.listLimit
        let page: Int = max((req.query[self.listPageKey] ?? 1), 1)

        var qb = try self.beforeList(req: req, queryBuilder: Model.query(on: req.db))
        
        if sort != nil || !self.listSortable.isEmpty {
            let customSort = sort ?? self.listSortable[0].description
            qb = qb.sort(.init(stringLiteral: customSort), order.sortDirection)
        }

        if let searchTerm = search, !searchTerm.isEmpty {
            qb = qb.group(.or) { self.search(using: $0, for: searchTerm) }
        }

        let start: Int = (page - 1) * limit
        let end: Int = page * limit
        
        let count = qb.count()
        let items = qb.copy().range(start..<end).all()

        return items.and(count).map { (models, total) -> CustomPage<Model> in
            let totalPages = Int(ceil(Float(total) / Float(limit)))
            return CustomPage(items: models, metadata: .init(page: page, per: limit, total: totalPages))
        }
        .map { $0.map(\.viewContext) }
        .flatMap { req.view.render(self.listView, $0) }
    }
}

