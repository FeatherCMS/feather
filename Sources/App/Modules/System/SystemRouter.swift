//
//  SystemRouter.swift
//  Feather
//
//  Created by Tibor Bödecs on 2020. 06. 10..
//

import Vapor
import ViperKit
import FeatherCore

final class SystemRouter: ViperRouter {

    let adminController = SystemVariableAdminController()

    func hook(name: String, routes: RoutesBuilder, app: Application) throws {
        switch name {
        case "admin":
            let adminModule = routes.grouped(.init(stringLiteral: SystemModule.name))
            adminController.setupRoutes(on: adminModule, as: SystemVariableModel.pathComponent)
        default:
            break;
        }
    }
}
