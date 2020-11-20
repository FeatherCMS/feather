//
//  AnalyticsRouter.swift
//  Analytics
//
//  Created by Tibor Bödecs on 2020. 11. 19..
//

import FeatherCore

final class AnalyticsRouter: ViperRouter {

    let overviewController = AnalyticsOverviewAdminController()
    let logController = AnalyticsLogAdminController()

    func hook(name: String, routes: RoutesBuilder, app: Application) throws {
        switch name {
        case "admin":
            let adminModule = routes.grouped(.init(stringLiteral: AnalyticsModule.name))
            let logs = adminModule.grouped(AnalyticsLogModel.pathComponent)
            logController.setupListRoute(on: logs)

            adminModule.get("overview", use: overviewController.overviewView)
        default:
            break;
        }
    }
}
