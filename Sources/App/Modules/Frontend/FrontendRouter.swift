//
//  FrontendRouter.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 01. 26..
//

import Vapor
import ViperKit
    
struct FrontendRouter: ViperRouter {
    
    let frontendController = FrontendController()
    var adminController = FrontendContentAdminController()

    func boot(routes: RoutesBuilder, app: Application) throws {
        let frontendRoutes = routes.grouped(FrontendNotFoundMiddleware())

        frontendRoutes.get(use: self.frontendController.catchAllView)
        frontendRoutes.get(.catchall, use: self.frontendController.catchAllView)

        routes.get("sitemap.xml", use: self.frontendController.sitemap)
        routes.get("rss.xml", use: self.frontendController.rss)
    }

    func hook(name: String, routes: RoutesBuilder, app: Application) throws {
        switch name {
        case "protected-admin":
            let adminModule = routes.grouped(.init(stringLiteral: FrontendModule.name))
            self.adminController.setupRoutes(routes: adminModule, on: .init(stringLiteral: FrontendContentModel.name))
        default:
            break;
        }
    }
}

