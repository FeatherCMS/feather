//
//  MenuRouter.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 11. 15..
//

import Vapor
import ViperKit

struct MenuRouter: ViperRouter {
    
    var adminController = MenuAdminController()

    func hook(name: String, routes: RoutesBuilder, app: Application) throws {
        switch name {
        case "admin":
            let adminModule = routes.grouped(.init(stringLiteral: MenuModule.name))
            adminController.setupRoutes(on: adminModule, as: MenuModel.pathComponent)
        default:
            break;
        }
    }
}

