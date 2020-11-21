//
//  BlogModule.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 01. 25..
//

import Fluent
import FeatherCore

final class BlogModule: ViperModule {

    static let name = "blog"
    var priority: Int { 1100 }

    var router: ViperRouter? = BlogRouter()
    

    var migrations: [Migration] {
        [
            BlogMigration_v1_0_0(),
        ]
    }
    
    static var bundleUrl: URL? {
        URL(fileURLWithPath: Application.Paths.base)
            .appendingPathComponent("Sources")
            .appendingPathComponent("App")
            .appendingPathComponent("Modules")
            .appendingPathComponent("Blog")
            .appendingPathComponent("Bundle")
    }

    func boot(_ app: Application) throws {
        app.databases.middleware.use(MetadataMiddleware<BlogPostModel>())
        app.databases.middleware.use(MetadataMiddleware<BlogCategoryModel>())
        app.databases.middleware.use(MetadataMiddleware<BlogAuthorModel>())
        
        
        app.hooks.register("admin", use: (router as! BlogRouter).adminRoutesHook)
        app.hooks.register("installer", use: installerHook)
        app.hooks.register("frontend-page", use: frontendPageHook)
        app.hooks.register("leaf-admin-menu", use: leafAdminMenuHook)
        
        app.hooks.register("home-page", use: homePageHook)
        app.hooks.register("categories-page", use: categoriesPageHook)
        app.hooks.register("authors-page", use: authorsPageHook)
        app.hooks.register("posts-page", use: postsPageHook)
    }

    // MARK: - hooks

    func leafAdminMenuHook(args: HookArguments) -> LeafDataRepresentable {
        [
            "name": "Blog",
            "icon": "book",
            "items": LeafData.array([
                [
                    "url": "/admin/blog/posts/",
                    "label": "Posts",
                ],
                [
                    "url": "/admin/blog/categories/",
                    "label": "Categories",
                ],
                [
                    "url": "/admin/blog/authors/",
                    "label": "Authors",
                ],
            ])
        ]
    }
    
    func installerHook(args: HookArguments) -> ViperInstaller {
        BlogInstaller()
    }

    func frontendPageHook(args: HookArguments) -> EventLoopFuture<Response?> {
        let req = args["req"] as! Request

        return Metadata.query(on: req.db)
            .filter(Metadata.self, \.$module == BlogModule.name)
            .filter(Metadata.self, \.$model ~~ [BlogPostModel.name, BlogCategoryModel.name, BlogAuthorModel.name])
            .filter(Metadata.self, \.$slug == req.url.path.trimmingSlashes())
            .filter(Metadata.self, \.$status != .archived)
            .first()
            .flatMap { [self] metadata -> EventLoopFuture<Response?> in
                guard let metadata = metadata else {
                    return req.eventLoop.future(nil)
                }
                if metadata.model == BlogPostModel.name {
                    return (router as! BlogRouter).frontend.postView(req, metadata)
                        .encodeOptionalResponse(for: req)
                }
                if metadata.model == BlogCategoryModel.name {
                    return (router as! BlogRouter).frontend.categoryView(req, metadata)
                        .encodeOptionalResponse(for: req)
                }
                if metadata.model == BlogAuthorModel.name {
                    return (router as! BlogRouter).frontend.authorView(req, metadata)
                        .encodeOptionalResponse(for: req)
                }
                return req.eventLoop.future(nil)
            }
    }
    
    /// renders the [home-page] content
    func homePageHook(args: HookArguments) -> EventLoopFuture<Response?> {
        let req = args["req"] as! Request
        let metadata = args["page-metadata"] as! Metadata
        
        return BlogPostModel
            .home(on: req)
            .flatMap { BlogFrontendView(req).home(posts: $0, metadata: metadata) }
            .encodeOptionalResponse(for: req)
    }

    /// renders the [categories-page] content
    func categoriesPageHook(args: HookArguments) -> EventLoopFuture<Response?> {
        let req = args["req"] as! Request
        let metadata = args["page-metadata"] as! Metadata
        
        return BlogCategoryModel
            .findPublished(on: req)
            .flatMap { BlogFrontendView(req).categories($0, metadata: metadata) }
            .encodeOptionalResponse(for: req)
    }

    /// renders the [authors-page] content
    func authorsPageHook(args: HookArguments) -> EventLoopFuture<Response?> {
        let req = args["req"] as! Request
        let metadata = args["page-metadata"] as! Metadata
        
        return BlogAuthorModel.findPublished(on: req)
            .flatMap { BlogFrontendView(req).authors($0, metadata: metadata) }
            .encodeOptionalResponse(for: req)
    }
    
    /// renders the [posts-page] content
    func postsPageHook(args: HookArguments) -> EventLoopFuture<Response?> {
        let req = args["req"] as! Request
        let metadata = args["page-metadata"] as! Metadata
        
        var qb = BlogPostModel.find(on: req)

        let search: String? = req.query["search"]
        let limit: Int = req.query["limit"] ?? 10
        let page: Int = max((req.query["page"] ?? 1), 1)

        if let searchTerm = search, !searchTerm.isEmpty {
            qb = qb.filter(\.$title ~~ searchTerm)
        }

        let start: Int = (page - 1) * limit
        let end: Int = page * limit

        let count = qb.count()
        let items = qb.copy().range(start..<end).all()

        return items.and(count).map { (posts, count) -> ViewKit.Page<LeafData> in
            let total = Int(ceil(Float(count) / Float(limit)))
            return .init(posts.map { $0.leafDataWithMetadata }, info: .init(current: page, limit: limit, total: total))
        }
        .flatMap { BlogFrontendView(req).posts(page: $0, metadata: metadata) }
        .encodeOptionalResponse(for: req)
    }
}
