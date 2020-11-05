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

        /// register publicly available api routes
        try invoke(name: "public-api", routes: publicApi, app: app)

        /// guard the api with auth middlewares, if there was no auth middlewares returned we simply stop the registration
        guard let middlewares = app.viper.invokeSyncHook(name: "api-auth-middlwares", type: [Middleware].self) else {
            return
        }

        /// register protected api endpoints
        let protectedApi = publicApi.grouped(middlewares)
        try invoke(name: "api", routes: protectedApi, app: app)
    }
}
