//
//  SystemRouter.swift
//  FeatherCMS
//
//  Created by Tibor Bödecs on 2020. 06. 10..
//

import Vapor
import ViperKit

final class SystemRouter: ViperRouter {

    let adminController = SystemVariableAdminController()

    func hook(name: String, routes: RoutesBuilder, app: Application) throws {
        switch name {
        case "protected-admin":
            let adminModule = routes.grouped(.init(stringLiteral: SystemModule.name))
            self.adminController.setupRoutes(routes: adminModule, on: .init(stringLiteral: SystemVariableModel.name))
        default:
            break;
        }
    }
}
