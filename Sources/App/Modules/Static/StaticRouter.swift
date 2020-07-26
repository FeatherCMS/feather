//
//  StaticRouter.swift
//  FeatherCMS
//
//  Created by Tibor Bödecs on 2020. 06. 07..
//

import Vapor
import ViperKit

final class StaticRouter: ViperRouter {

    let adminController = StaticPageAdminController()

    func hook(name: String, routes: RoutesBuilder, app: Application) throws {
        switch name {
        case "protected-admin":
            let module = routes.grouped(.init(stringLiteral: StaticModule.name))
            self.adminController.setupRoutes(routes: module, on: .init(stringLiteral: StaticPageModel.name))
        default:
            break;
        }
    }
}
