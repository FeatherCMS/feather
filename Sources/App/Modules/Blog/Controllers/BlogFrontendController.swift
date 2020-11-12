//
//  BlogFrontendController.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 03. 27..
//

import Fluent
import FeatherCore

struct BlogFrontendController {

    func homeView(req: Request, page content: Metadata) throws -> EventLoopFuture<Response> {
        BlogPostModel
            .home(on: req)
            .flatMap { BlogFrontendView(req).home(posts: $0) }
            .encodeResponse(for: req)
    }
    
    func categoriesView(req: Request, page content: Metadata) throws -> EventLoopFuture<Response> {
        BlogCategoryModel
            .findPublished(on: req)
            .flatMap { BlogFrontendView(req).categories($0) }
            .encodeResponse(for: req)
    }
    
    func categoryView(_ req: Request, _ metadata: Metadata) -> EventLoopFuture<View> {
        BlogCategoryModel
            .findBy(id: metadata.reference, on: req)
            .and(BlogPostModel.findByCategory(id: metadata.reference, on: req))
            .flatMap { BlogFrontendView(req).category($0, posts: $1) }
    }
    
    func authorsView(req: Request, page content: Metadata) throws -> EventLoopFuture<Response> {
        BlogAuthorModel.findPublished(on: req)
            .flatMap { BlogFrontendView(req).authors($0) }
            .encodeResponse(for: req)
    }

    func authorView(_ req: Request, _ metadata: Metadata) -> EventLoopFuture<View> {
        BlogAuthorModel
            .findBy(id: metadata.reference, on: req)
            .and(BlogPostModel.findByAuthor(id: metadata.reference, on: req))
            .flatMap { BlogFrontendView(req).author($0, posts: $1) }
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

        return items.and(count).map { (posts, count) -> ViewKit.Page<LeafData> in
            let total = Int(ceil(Float(count) / Float(limit)))
            return .init(posts.map { $0.joinedMetadata() }, info: .init(current: page, limit: limit, total: total))
        }
        .flatMap { BlogFrontendView(req).posts(page: $0) }
        .encodeResponse(for: req)
    }

    func postView(_ req: Request, _ metadata: Metadata) -> EventLoopFuture<View> {
        BlogPostModel
            .findBy(id: metadata.reference, on: req)
            .flatMap { BlogFrontendView(req).post($0) }
    }
}
