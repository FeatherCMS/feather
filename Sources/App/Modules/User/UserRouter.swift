//
//  UserRouter.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 01. 24..
//

import Vapor
import ViperKit

struct UserRouter: ViperRouter {
    
    let userFrontendController = UserFrontendController()
    let userAdminController = UserAdminController()

    func boot(routes: RoutesBuilder, app: Application) throws {
        routes.get("login", use: userFrontendController.loginView)
        routes.grouped(UserModelCredentialsAuthenticator()).post("login", use: userFrontendController.login)
        routes.get("logout", use: userFrontendController.logout)
    }

    func hook(name: String, routes: RoutesBuilder, app: Application) throws {
        switch name {
        case "admin":
            let adminModule = routes.grouped(.init(stringLiteral: UserModule.name))

            userAdminController.setupRoutes(on: adminModule, as: .init(stringLiteral: UserModel.name))
//        case "protected-api":
//            let apiModule = routes.grouped("users")
//            apiModule.get("users", use: userApiController.users)
//            apiModule.post("users", use: userApiController.createUser)
        default:
            break;
        }
    }
}
