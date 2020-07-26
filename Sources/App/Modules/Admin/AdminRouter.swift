//
//  AdminRouter.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 04. 29..
//

import Vapor
import ViperKit

struct AdminRouter: ViperRouter {
    
    let adminController = AdminController()
    
    func boot(routes: RoutesBuilder, app: Application) throws {
        let publicAdmin = routes.grouped("admin")
        let protectedAdmin = publicAdmin.grouped(UserModel.redirectMiddleware(path: "/login"))
        
        protectedAdmin.get(use: self.adminController.adminView)

        try self.invoke(name: "public-admin", routes: publicAdmin, app: app)
        try self.invoke(name: "protected-admin", routes: protectedAdmin, app: app)
    }
}
