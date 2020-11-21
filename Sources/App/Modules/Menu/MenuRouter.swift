//
//  MenuRouter.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 11. 15..
//

import FeatherCore

struct MenuRouter: ViperRouter {
    
    let menuAdmin = MenuAdminController()
    let itemAdmin = MenuItemAdminController()

    func adminRoutesHook(args: HookArguments) {
        let routes = args["routes"] as! RoutesBuilder

        let modulePath = routes.grouped(MenuModule.pathComponent)
        menuAdmin.setupRoutes(on: modulePath, as: MenuModel.pathComponent)

        let itemPath = modulePath.grouped(.init(stringLiteral: MenuModel.name), menuAdmin.idPathComponent)
        itemAdmin.setupRoutes(on: itemPath, as: MenuItemModel.pathComponent)
    }
}

