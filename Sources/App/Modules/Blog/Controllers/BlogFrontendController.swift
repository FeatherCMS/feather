//
//  BlogFrontendController.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 03. 27..
//

import Vapor
import Fluent
import ViperKit
import ViewKit

struct BlogFrontendController {

    func homeView(req: Request, page content: FrontendContentModel) throws -> EventLoopFuture<Response> {
        BlogPostModel.query(on: req.db)
        .join(FrontendContentModel.self, on: \BlogPostModel.$id == \FrontendContentModel.$reference, method: .inner)
        .filter(FrontendContentModel.self, \.$status == .published)
        .sort(FrontendContentModel.self, \.$date, .descending)
        .range(..<17)
        .with(\.$category)
        .all()
        .flatMap { posts -> EventLoopFuture<View> in
            let items = posts.map { post -> BlogPostContext in
                let content = try! post.joined(FrontendContentModel.self)
                return .init(post: post.viewContext, category: post.category.viewContext, content: content.viewContext)
            }
            return req.view.render("Blog/Frontend/Home", HTMLContext(content.headContext, ListContext(items)))
        }
        .encodeResponse(for: req)
    }
    
    func postsView(req: Request, page content: FrontendContentModel) throws -> EventLoopFuture<Response> {
        let search: String? = req.query["search"]
        let limit: Int = req.query["limit"] ?? 10
        let page: Int = max((req.query["page"] ?? 1), 1)

        var qb = BlogPostModel.joinedFrontendContentQuery(on: req.db)
        .filter(FrontendContentModel.self, \.$status == .published)
        .with(\.$category)
        if let searchTerm = search, !searchTerm.isEmpty {
            qb = qb.filter(\.$title ~~ searchTerm)
        }

        let start: Int = (page - 1) * limit
        let end: Int = page * limit
        
        let count = qb.count()
        let items = qb.copy().range(start..<end).all()

        return items.and(count).map { (posts, total) -> CustomPage<BlogPostContext> in
            let items = posts.map { post -> BlogPostContext in
                let pc = try! post.joined(FrontendContentModel.self)
                return .init(post: post.viewContext, category: post.category.viewContext, content: pc.viewContext)
            }
            let totalPages = Int(ceil(Float(total) / Float(limit)))
            return CustomPage(items: items, metadata: .init(page: page, per: limit, total: totalPages))
        }
        .flatMap { ctx -> EventLoopFuture<View> in
            return req.view.render("Blog/Frontend/Posts", HTMLContext(content.headContext, ctx))
        }
        .encodeResponse(for: req)
    }
    
    func categoriesView(req: Request, page content: FrontendContentModel) throws -> EventLoopFuture<Response> {
        BlogCategoryModel.joinedFrontendContentQuery(on: req.db)
        .filter(FrontendContentModel.self, \.$status == .published)
        .all()
        .flatMap { categories -> EventLoopFuture<View> in
            struct CategoryContext: Encodable {
                let category: BlogCategoryModel.ViewContext
                let content: FrontendContentModel.ViewContext
            }
            let items = categories.map { category -> CategoryContext in
                let categoryContent = try! category.joined(FrontendContentModel.self)
                return .init(category: category.viewContext, content: categoryContent.viewContext)
            }
            return req.view.render("Blog/Frontend/Categories", HTMLContext(content.headContext, ListContext(items)))
        }
        .encodeResponse(for: req)
    }
    
    func authorsView(req: Request, page content: FrontendContentModel) throws -> EventLoopFuture<Response> {
        BlogAuthorModel.joinedFrontendContentQuery(on: req.db)
        .filter(FrontendContentModel.self, \.$status == .published)
        .all()
        .flatMap { categories -> EventLoopFuture<View> in
            struct AuthorContext: Encodable {
                let author: BlogAuthorModel.ViewContext
                let content: FrontendContentModel.ViewContext
            }
            let items = categories.map { author -> AuthorContext in
                let authorContent = try! author.joined(FrontendContentModel.self)
                return .init(author: author.viewContext, content: authorContent.viewContext)
            }
            return req.view.render("Blog/Frontend/Authors", HTMLContext(content.headContext, ListContext(items)))
        }
        .encodeResponse(for: req)
    }
}
