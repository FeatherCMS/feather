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

    let _router = BlogRouter()
    var router: ViperRouter? { _router }
    
    func boot(_ app: Application) throws {
        app.databases.middleware.use(MetadataMiddleware<BlogPostModel>())
        app.databases.middleware.use(MetadataMiddleware<BlogCategoryModel>())
        app.databases.middleware.use(MetadataMiddleware<BlogAuthorModel>())
    }

    var migrations: [Migration] {
        [
            BlogMigration_v1_0_0(),
        ]
    }

    var viewsUrl: URL? {
        nil
//        Bundle.module.bundleURL
//            .appendingPathComponent("Contents")
//            .appendingPathComponent("Resources")
//            .appendingPathComponent("Views")
    }

    // MARK: - hook functions

    func invoke(name: String, req: Request, params: [String : Any] = [:]) -> EventLoopFuture<Any?>? {
        switch name {
        case "frontend-page":
            return frontendPageHook(req: req)
        case "home-page":
            let metadata = params["page-metadata"] as! Metadata
            return _router.frontend.homeView(req: req, metadata).erase()
        case "posts-page":
            let metadata = params["page-metadata"] as! Metadata
            return _router.frontend.postsView(req: req, metadata).erase()
        case "categories-page":
            let metadata = params["page-metadata"] as! Metadata
            return _router.frontend.categoriesView(req: req, metadata).erase()
        case "authors-page":
            let metadata = params["page-metadata"] as! Metadata
            return _router.frontend.authorsView(req: req, metadata).erase()
        default:
            return nil
        }
    }
    
    func invokeSync(name: String, req: Request?, params: [String : Any]) -> Any? {
        switch name {
        case "installer":
            return BlogInstaller()
        case "leaf-admin-menu":
            return [
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
        default:
            return nil
        }
    }

    private func frontendPageHook(req: Request) -> EventLoopFuture<Any?>? {
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
                    return _router.frontend.postView(req, metadata)
                        .encodeResponse(for: req).map { $0 as Response? }
                }
                if metadata.model == BlogCategoryModel.name {
                    return _router.frontend.categoryView(req, metadata)
                        .encodeResponse(for: req).map { $0 as Response? }
                }
                if metadata.model == BlogAuthorModel.name {
                    return _router.frontend.authorView(req, metadata)
                        .encodeResponse(for: req).map { $0 as Response? }
                }
                return req.eventLoop.future(nil)
            }
            .map { $0 as Any }
    }
}
