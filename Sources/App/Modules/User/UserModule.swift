//
//  UserModule.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 01. 25..
//

import Vapor
import Fluent
import ViperKit
import FeatherCore
//import UserApi

final class UserModule: ViperModule {

    static let name = "user"
    var priority: Int { 2 }
    
    var router: ViperRouter? = UserRouter()
    
    var middlewares: [Middleware] = [
        UserModelSessionAuthenticator()
    ]
    
    func boot(_ app: Application) throws {
        app.databases.middleware.use(UserModelContentMiddleware())
    }

    var migrations: [Migration] {
        [
            UserMigration_v1_0_0(),
        ]
    }

    var viewsUrl: URL? {
        nil
//        Bundle.module.bundleURL
//            .appendingPathComponent("Contents")
//            .appendingPathComponent("Resources")
//            .appendingPathComponent("Views")
    }
    
    // MARK: - hook functions

    func invoke(name: String, req: Request, params: [String : Any] = [:]) -> EventLoopFuture<Any?>? {
        
        switch name {
        case "install":
            return installHook(req: req)
        default:
            return nil
        }
    }
    
    func invokeSync(name: String, req: Request?, params: [String : Any]) -> Any? {
        switch name {
        case "admin-auth-middlwares":
            return [UserModel.redirectMiddleware(path: "/login")]
        case "api-auth-middlwares":
            return [UserTokenModel.authenticator(), UserModel.guardMiddleware()]
        default:
            return nil
        }
    }

}
