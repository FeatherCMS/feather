//
//  BlogRouter.swift
//  Feather
//
//  Created by Tibor Bodecs on 2019. 12. 17..
//

import FeatherCore

struct BlogRouter: ViperRouter {

    let postAdmin = BlogPostAdminController()
    let authorAdmin = BlogAuthorAdminController()
    let categoryAdmin = BlogCategoryAdminController()
    let linkAdmin = BlogAuthorLinkAdminController()
    let frontend = BlogFrontendController()

    func hook(name: String, routes: RoutesBuilder, app: Application) throws {
        switch name {
        case "admin":
            let module = routes.grouped(.init(stringLiteral: BlogModule.name))

            postAdmin.setupRoutes(on: module, as: BlogPostModel.pathComponent)
            categoryAdmin.setupRoutes(on: module, as: BlogCategoryModel.pathComponent)
            

            authorAdmin.setupRoutes(on: module, as: BlogAuthorModel.pathComponent)
            
            let adminAuthor = module.grouped(.init(stringLiteral: BlogAuthorModel.name),
                                             .init(stringLiteral: ":" + authorAdmin.idParamKey))
            linkAdmin.setupRoutes(on: adminAuthor, as: BlogAuthorLinkModel.pathComponent)
        default:
            break;
        }
    }
}

