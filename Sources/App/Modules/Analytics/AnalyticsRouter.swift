//
//  AnalyticsRouter.swift
//  Analytics
//
//  Created by Tibor Bödecs on 2020. 11. 19..
//

import FeatherCore

final class AnalyticsRouter: ViperRouter {

    let adminOverview = AnalyticsOverviewAdminController()
    let adminLog = AnalyticsLogAdminController()

    func adminRoutesHook(args: HookArguments) {
        let routes = args["routes"] as! RoutesBuilder
        
        let modulePath = routes.grouped(AnalyticsModule.pathComponent)
        let logs = modulePath.grouped(AnalyticsLogModel.pathComponent)
        adminLog.setupListRoute(on: logs)
        modulePath.get("overview", use: adminOverview.overviewView)
    }

}
