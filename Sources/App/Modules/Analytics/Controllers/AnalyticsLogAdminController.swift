//
//  AnalyticsFrontendController.swift
//  Analytics
//
//  Created by Tibor Bödecs on 2020. 11. 19..
//

import Fluent
import FeatherCore

struct AnalyticsLogAdminController: ListViewController {
    
    typealias Module = AnalyticsModule
    typealias Model = AnalyticsLogModel

    var listView: String { "\(Module.name.capitalized)/Admin/\(Model.name.capitalized)/List" }

    var listAllowedOrders: [FieldKey] = [
        Model.FieldKeys.date,
        Model.FieldKeys.path,
        Model.FieldKeys.language,
        Model.FieldKeys.region,
        Model.FieldKeys.osName,
        Model.FieldKeys.osVersion,
        Model.FieldKeys.browserName,
        Model.FieldKeys.browserVersion,
    ]

    func search(using qb: QueryBuilder<Model>, for searchTerm: String) {
        qb.filter(\.$path ~~ searchTerm)
        qb.filter(\.$osName ~~ searchTerm)
        qb.filter(\.$browserName ~~ searchTerm)
    }
}
