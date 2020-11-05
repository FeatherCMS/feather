//
//  BlogFrontendController.swift
//  FeatherCMS
//
//  Created by Tibor Bodecs on 2020. 03. 27..
//

import Fluent
import FeatherCore

struct BlogFrontendController {

    func homeView(req: Request, page content: Metadata) throws -> EventLoopFuture<Response> {
        BlogPostModel.query(on: req.db)
        .join(Metadata.self, on: \BlogPostModel.$id == \Metadata.$reference, method: .inner)
        .filter(Metadata.self, \.$status == .published)
        .sort(Metadata.self, \.$date, .descending)
        .range(..<17)
        .with(\.$category)
        .all()
        .flatMap { posts -> EventLoopFuture<View> in
//            let items = posts.map { post -> BlogPostContext in
//                let content = try! post.joined(Metadata.self)
//                return .init(post: post.viewContext, category: post.category.viewContext, content: content.viewContext)
//            }
            return req.leaf.render(template: "Blog/Frontend/Home", context: [:])
        }
        .encodeResponse(for: req)
    }
    
    func postsView(req: Request, page content: Metadata) throws -> EventLoopFuture<Response> {
        let search: String? = req.query["search"]
        let limit: Int = req.query["limit"] ?? 10
        let page: Int = max((req.query["page"] ?? 1), 1)

        var qb = BlogPostModel.findMetadata(on: req.db)
        .filter(Metadata.self, \.$status == .published)
        .with(\.$category)
        if let searchTerm = search, !searchTerm.isEmpty {
            qb = qb.filter(\.$title ~~ searchTerm)
        }

        let start: Int = (page - 1) * limit
        let end: Int = page * limit
        
        let count = qb.count()
        let items = qb.copy().range(start..<end).all()

//        return items.and(count).map { (posts, total) -> ViewKit.Page<BlogPostContext> in
//            let items = posts.map { post -> BlogPostContext in
//                let pc = try! post.joined(Metadata.self)
//                return .init(post: post.viewContext, category: post.category.viewContext, content: pc.viewContext)
//            }
//            let totalPages = Int(ceil(Float(total) / Float(limit)))
//            return PageContext(items: items, metadata: .init(page: page, limit: limit, total: totalPages))
//        }
//        .flatMap { ctx -> EventLoopFuture<View> in
        return req.leaf.render(template: "Blog/Frontend/Posts", context: [:])
//        }
        .encodeResponse(for: req)
    }
    
    func categoriesView(req: Request, page content: Metadata) throws -> EventLoopFuture<Response> {
        BlogCategoryModel.findMetadata(on: req.db)
        .filter(Metadata.self, \.$status == .published)
        .all()
        .flatMap { categories -> EventLoopFuture<View> in
            
//            let items = categories.map { category -> CategoryContext in
//                let categoryContent = try! category.joined(Metadata.self)
//                return .init(category: category.viewContext, content: categoryContent.viewContext)
//            }
            return req.leaf.render(template: "Blog/Frontend/Categories", context: [:])
        }
        .encodeResponse(for: req)
    }
    
    func authorsView(req: Request, page content: Metadata) throws -> EventLoopFuture<Response> {
        BlogAuthorModel.findMetadata(on: req.db)
        .filter(Metadata.self, \.$status == .published)
        .all()
        .flatMap { categories -> EventLoopFuture<View> in
            
//            let items = categories.map { author -> AuthorContext in
//                let authorContent = try! author.joined(Metadata.self)
//                return .init(author: author.viewContext, content: authorContent.viewContext)
//            }
            return req.leaf.render(template: "Blog/Frontend/Authors", context: [:])
        }
        .encodeResponse(for: req)
    }
}
