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

    func adminRoutesHook(args: HookArguments) {
        let routes = args["routes"] as! RoutesBuilder

        let modulePath = routes.grouped(BlogModule.pathComponent)

        postAdmin.setupRoutes(on: modulePath, as: BlogPostModel.pathComponent)
        categoryAdmin.setupRoutes(on: modulePath, as: BlogCategoryModel.pathComponent)

        authorAdmin.setupRoutes(on: modulePath, as: BlogAuthorModel.pathComponent)

        let adminAuthor = modulePath.grouped(BlogAuthorModel.pathComponent, authorAdmin.idPathComponent)
        linkAdmin.setupRoutes(on: adminAuthor, as: BlogAuthorLinkModel.pathComponent)
        
    }
}

