//
//  SiteRouter.swift
//  Site
//
//  Created by Tibor Bödecs on 2020. 11. 19..
//

import FeatherCore

final class SiteRouter: ViperRouter {

    let adminController = SiteAdminController()

    func adminRoutesHook(args: HookArguments) {
        let routes = args["routes"] as! RoutesBuilder

        let adminModule = routes.grouped(SiteModule.pathComponent)
        adminModule.get("settings", use: adminController.settingsView)
        adminModule.post("settings", use: adminController.updateSettings)
    }
    
}
