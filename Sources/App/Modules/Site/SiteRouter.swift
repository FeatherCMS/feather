//
//  SiteRouter.swift
//  Site
//
//  Created by Tibor Bödecs on 2020. 11. 19..
//

import FeatherCore

final class SiteRouter: ViperRouter {

    let adminController = SiteAdminController()


    func hook(name: String, routes: RoutesBuilder, app: Application) throws {
        switch name {
        case "admin":
            let adminModule = routes.grouped(SiteModule.pathComponent)
            adminModule.get("settings", use: adminController.settingsView)
            adminModule.post("settings", use: adminController.updateSettings)
        default:
            break;
        }
    }
}
