//
//  UserRouter.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 01. 24..
//

import Vapor
import ViperKit

struct UserRouter: ViperRouter {
    
    let userFrontendController = UserFrontendController()
    let userAdminController = UserAdminController()
    
    func boot(routes: RoutesBuilder, app: Application) throws {
        routes.get("login", use: self.userFrontendController.loginView)
        routes.grouped(UserModelCredentialsAuthenticator()).post("login", use: self.userFrontendController.login)
        routes.get("logout", use: self.userFrontendController.logout)
    }

    func hook(name: String, routes: RoutesBuilder, app: Application) throws {
        switch name {
        case "protected-admin":
            let adminModule = routes.grouped(.init(stringLiteral: UserModule.name))
            self.userAdminController.setupRoutes(routes: adminModule, on: .init(stringLiteral: UserModel.name))
//        case "protected-api":
//            let apiModule = routes.grouped("users")
//            apiModule.get("users", use: self.userApiController.users)
//            apiModule.post("users", use: self.userApiController.createUser)
        default:
            break;
        }
    }
}
