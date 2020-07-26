//
//  BlogRouter.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2019. 12. 17..
//

import Vapor
import ViperKit

struct BlogRouter: ViperRouter {

    let postAdminController = BlogPostAdminController()
    let authorAdminController = BlogAuthorAdminController()
    let categoryAdminController = BlogCategoryAdminController()
    let linkAdminController = BlogAuthorLinkAdminController()

    func hook(name: String, routes: RoutesBuilder, app: Application) throws {
        switch name {
        case "protected-admin":
            let module = routes.grouped(.init(stringLiteral: BlogModule.name))
            self.postAdminController.setupRoutes(routes: module, on: .init(stringLiteral: BlogPostModel.name))
            self.categoryAdminController.setupRoutes(routes: module, on: .init(stringLiteral: BlogCategoryModel.name))
            

            self.authorAdminController.setupRoutes(routes: module, on: .init(stringLiteral: BlogAuthorModel.name))
            
            let adminAuthor = module.grouped(.init(stringLiteral: BlogAuthorModel.name),
                                             .init(stringLiteral: ":" + self.authorAdminController.idParamKey))
            self.linkAdminController.setupRoutes(routes: adminAuthor, on: BlogAuthorLinkModel.pathComponent)
        default:
            break;
        }
    }
}

