//
//  RedirectRouter.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 01. 24..
//

import Vapor
import ViperKit

struct RedirectRouter: ViperRouter {
    
    var adminController = RedirectAdminController()

    func hook(name: String, routes: RoutesBuilder, app: Application) throws {
        switch name {
        case "admin":
            let adminModule = routes.grouped(.init(stringLiteral: RedirectModule.name))
            adminController.setupRoutes(on: adminModule, as: RedirectModel.pathComponent)
        default:
            break;
        }
    }
}

