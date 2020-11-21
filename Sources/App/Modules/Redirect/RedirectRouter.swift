//
//  RedirectRouter.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 01. 24..
//

import FeatherCore

struct RedirectRouter: ViperRouter {
    
    var adminController = RedirectAdminController()

    func adminRoutesHook(args: HookArguments) {
        let routes = args["routes"] as! RoutesBuilder

        let modulePath = routes.grouped(RedirectModule.pathComponent)
        adminController.setupRoutes(on: modulePath, as: RedirectModel.pathComponent)
    }
}
