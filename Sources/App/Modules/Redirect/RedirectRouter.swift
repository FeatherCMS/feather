//
//  RedirectRouter.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 01. 24..
//

import Vapor
import ViperKit

struct RedirectRouter: ViperRouter {
    
    var adminController = RedirectAdminController()

    func hook(name: String, routes: RoutesBuilder, app: Application) throws {
        switch name {
        case "protected-admin":
            let adminModule = routes.grouped(.init(stringLiteral: RedirectModule.name))
            self.adminController.setupRoutes(routes: adminModule, on: .init(stringLiteral: RedirectModel.name))
        default:
            break;
        }
    }
}

