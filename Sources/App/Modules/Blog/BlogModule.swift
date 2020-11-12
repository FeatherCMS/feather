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
        case "install":
            return installHook(req: req)
        case "frontend-page":
            return frontendPageHook(req: req)
        case "home-page":
            let content = params["page-content"] as! Metadata
            return try? _router.frontend.homeView(req: req, page: content).map { $0 as Any }
        case "posts-page":
            let content = params["page-content"] as! Metadata
            return try? _router.frontend.postsView(req: req, page: content).map { $0 as Any }
        case "categories-page":
            let content = params["page-content"] as! Metadata
            return try? _router.frontend.categoriesView(req: req, page: content).map { $0 as Any }
        case "authors-page":
            let content = params["page-content"] as! Metadata
            return try? _router.frontend.authorsView(req: req, page: content).map { $0 as Any }
        default:
            return nil
        }
    }

    private func frontendPageHook(req: Request) -> EventLoopFuture<Any?>? {
        return Metadata.query(on: req.db)
            .filter(Metadata.self, \.$module == BlogModule.name)
            .filter(Metadata.self, \.$model ~~ [BlogPostModel.name, BlogCategoryModel.name, BlogAuthorModel.name])
            .filter(Metadata.self, \.$slug == req.url.path.safeSlug())
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
