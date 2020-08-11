//
//  UserModule.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 01. 25..
//

import Vapor
import Fluent
import ViperKit

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
    
    var tags: [ViperLeafTag] = [
        UserIsAuthenticatedTag()
    ]
    
    // MARK: - hook functions

    func invoke(name: String, req: Request, params: [String : Any] = [:]) -> EventLoopFuture<Any?>? {
        switch name {
        case "install":
            return self.installHook(req: req)
        default:
            return nil
        }
    }

}
