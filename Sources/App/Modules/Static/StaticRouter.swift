//
//  StaticRouter.swift
//  Feather
//
//  Created by Tibor Bödecs on 2020. 06. 07..
//

import FeatherCore

final class StaticRouter: ViperRouter {

    let adminController = StaticPageAdminController()

    func adminRoutesHook(args: HookArguments) {
        let routes = args["routes"] as! RoutesBuilder

        let modulePath = routes.grouped(StaticModule.pathComponent)
        adminController.setupRoutes(on: modulePath, as: StaticPageModel.pathComponent)
    }
}
