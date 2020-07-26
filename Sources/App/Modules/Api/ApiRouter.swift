//
//  ApiRouter.swift
//  FeatherCMS
//
//  Created by Tibor Bödecs on 2020. 06. 09..
//

import Vapor
import ViperKit

final class ApiRouter: ViperRouter {

    func boot(routes: RoutesBuilder, app: Application) throws {
        let publicApi = routes.grouped("api")
        let protectedApi = routes.grouped(UserTokenModel.authenticator(),
                                          UserModel.guardMiddleware())

        try self.invoke(name: "public-api", routes: publicApi, app: app)
        try self.invoke(name: "protected-api", routes: protectedApi, app: app)
    }
}
