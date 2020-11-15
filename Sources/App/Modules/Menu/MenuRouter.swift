//
//  MenuRouter.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 11. 15..
//

import Vapor
import ViperKit

struct MenuRouter: ViperRouter {
    
    let menuAdmin = MenuAdminController()
    let itemAdmin = MenuItemAdminController()

    func hook(name: String, routes: RoutesBuilder, app: Application) throws {
        switch name {
        case "admin":
            let module = routes.grouped(.init(stringLiteral: MenuModule.name))
            menuAdmin.setupRoutes(on: module, as: MenuModel.pathComponent)
            
            let adminItems = module.grouped(.init(stringLiteral: MenuModel.name),
                                            .init(stringLiteral: ":" + menuAdmin.idParamKey))
            itemAdmin.setupRoutes(on: adminItems, as: MenuItemModel.pathComponent)
        default:
            break;
        }
    }
}

