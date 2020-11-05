//
//  BlogRouter.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2019. 12. 17..
//

import Vapor
import ViperKit
import FeatherCore

struct BlogRouter: ViperRouter {

    let postAdminController = BlogPostAdminController()
    let authorAdminController = BlogAuthorAdminController()
    let categoryAdminController = BlogCategoryAdminController()
    let linkAdminController = BlogAuthorLinkAdminController()

    func hook(name: String, routes: RoutesBuilder, app: Application) throws {
        switch name {
        case "admin":
            let module = routes.grouped(.init(stringLiteral: BlogModule.name))

            postAdminController.setupRoutes(on: module, as: BlogPostModel.pathComponent)
            categoryAdminController.setupRoutes(on: module, as: BlogCategoryModel.pathComponent)
            

            authorAdminController.setupRoutes(on: module, as: BlogAuthorModel.pathComponent)
            
            let adminAuthor = module.grouped(.init(stringLiteral: BlogAuthorModel.name),
                                             .init(stringLiteral: ":" + authorAdminController.idParamKey))
            linkAdminController.setupRoutes(on: adminAuthor, as: BlogAuthorLinkModel.pathComponent)
        default:
            break;
        }
    }
}

