//
//  BlogModule.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 01. 25..
//

import Vapor
import Fluent
import ViperKit
import ViewKit

final class BlogModule: ViperModule {

    static let name = "blog"
        
    var router: ViperRouter? = BlogRouter()
    
    func boot(_ app: Application) throws {
        app.databases.middleware.use(FrontendContentModelMiddleware<BlogPostModel>())
        app.databases.middleware.use(FrontendContentModelMiddleware<BlogCategoryModel>())
        app.databases.middleware.use(FrontendContentModelMiddleware<BlogAuthorModel>())
    }

    var migrations: [Migration] {
        [
            BlogMigration_v1_0_0(),
        ]
    }

    // MARK: - hook functions

    func invoke(name: String, req: Request, params: [String : Any] = [:]) -> EventLoopFuture<Any?>? {
        switch name {
        case "install":
            return self.installHook(req: req)
        case "frontend-page":
            return self.frontendPageHook(req: req)
        case "home-page":
            let content = params["page-content"] as! FrontendContentModel
            return try? BlogFrontendController().homeView(req: req, page: content).map { $0 as Any }
        case "posts-page":
            let content = params["page-content"] as! FrontendContentModel
            return try? BlogFrontendController().postsView(req: req, page: content).map { $0 as Any }
        case "categories-page":
            let content = params["page-content"] as! FrontendContentModel
            return try? BlogFrontendController().categoriesView(req: req, page: content).map { $0 as Any }
        case "authors-page":
            let content = params["page-content"] as! FrontendContentModel
            return try? BlogFrontendController().authorsView(req: req, page: content).map { $0 as Any }
        default:
            return nil
        }
    }

    private func frontendPageHook(req: Request) -> EventLoopFuture<Any?>? {
        return FrontendContentModel.query(on: req.db)
            .filter(FrontendContentModel.self, \.$module == BlogModule.name)
            .filter(FrontendContentModel.self, \.$model ~~ [BlogPostModel.name, BlogCategoryModel.name, BlogAuthorModel.name])
            .filter(FrontendContentModel.self, \.$slug == req.url.path.safeSlug())
            .filter(FrontendContentModel.self, \.$status != .archived)
            .first()
            .flatMap { content -> EventLoopFuture<Response?> in
                guard let content = content else {
                    return req.eventLoop.future(nil)
                }
                if content.model == BlogPostModel.name {
                    return self.renderPost(req, content).encodeResponse(for: req).map { $0 as Response? }
                }
                if content.model == BlogCategoryModel.name {
                    return self.renderCategory(req, content).encodeResponse(for: req).map { $0 as Response? }
                }
                if content.model == BlogAuthorModel.name {
                    return self.renderAuthor(req, content).encodeResponse(for: req).map { $0 as Response? }
                }
                return req.eventLoop.future(nil)
            }
            .map { $0 as Any }
    }
    
    private func renderCategory(_ req: Request, _ content: FrontendContentModel) -> EventLoopFuture<View> {
        BlogPostModel.joinedFrontendContentQuery(on: req.db)
        .filter(\.$category.$id == content.reference)
        .all()
        .and(BlogCategoryModel.find(content.reference, on: req.db).unwrap(or: Abort(.notFound)))
        .flatMap { posts, category in
            let items = posts.map { post -> BlogPostContext in
                let postContent = try! post.joined(FrontendContentModel.self)
                return .init(post: post.viewContext, category: category.viewContext, content: postContent.viewContext)
            }
            struct Context: Encodable {
                let category: BlogCategoryModel.ViewContext
                let items: [BlogPostContext]
            }

            let ctx = Context(category: category.viewContext, items: items)
            return req.view.render("Blog/Frontend/Category", HTMLContext(content.headContext, ctx))
        }
    }
    
    private func renderAuthor(_ req: Request, _ content: FrontendContentModel) -> EventLoopFuture<View> {
        BlogPostModel.joinedFrontendContentQuery(on: req.db)
        .filter(\.$author.$id == content.reference)
        .with(\.$category)
        .all()
        .and(BlogAuthorModel
                .query(on: req.db)
                .filter(\.$id == content.reference)
                .with(\.$links)
                .first().unwrap(or: Abort(.notFound)))
        .flatMap { posts, author in
            let items = posts.map { post -> BlogPostContext in
                let postContent = try! post.joined(FrontendContentModel.self)
                return .init(post: post.viewContext, category: post.category.viewContext, content: postContent.viewContext)
            }
            let authorLinks = author.links
                .sorted { $0.priority > $1.priority }
                .map(\.viewContext)
            
            print(authorLinks)
            struct Context: Encodable {
                struct AuthorWithLinksViewContext: Encodable {
                    var profile: BlogAuthorModel.ViewContext
                    var links: [BlogAuthorLinkModel.ViewContext]
                }
                
                let author: AuthorWithLinksViewContext
                let items: [BlogPostContext]
            }

            let ctx = Context(author: .init(profile: author.viewContext, links: authorLinks), items: items)
            return req.view.render("Blog/Frontend/Author", HTMLContext(content.headContext, ctx))
        }
    }
    
    private func renderPost(_ req: Request, _ content: FrontendContentModel) -> EventLoopFuture<View> {
        return BlogPostModel
        .query(on: req.db)
        .filter(\.$id == content.reference)
        .with(\.$category)
        .with(\.$author)
        .first()
        .flatMap { post -> EventLoopFuture<(BlogPostModel, [BlogAuthorLinkModel])>  in
            guard post != nil else {
                return req.eventLoop.future((post!, []))
            }
            // TODO: rewrite this with a joined query...
            return BlogAuthorLinkModel.query(on: req.db).all().map { links in
                return (post!, links)
            }
        }
        .flatMap { (post, links) -> EventLoopFuture<View> in
            let authorLinks = links
                .filter { $0.$author.id == post.author.id }
                .sorted { $0.priority > $1.priority }
                .map(\.viewContext)
            
            struct ViewContext: Encodable {
                struct AuthorWithLinksViewContext: Encodable {
                    var profile: BlogAuthorModel.ViewContext
                    var links: [BlogAuthorLinkModel.ViewContext]
                }
                var post: BlogPostModel.ViewContext
                var category: BlogCategoryModel.ViewContext
                var author: AuthorWithLinksViewContext
            }

            var postViewContext = post.viewContext
            postViewContext.content = content.filter(postViewContext.content, req: req)

            let context = ViewContext(post: postViewContext,
                                      category: post.category.viewContext,
                                      author: .init(profile: post.author.viewContext,
                                                    links: authorLinks))

            return req.view.render("Blog/Frontend/Post", HTMLContext(content.headContext, context))
        }
    }
    
}
