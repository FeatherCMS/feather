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
            .query(on: req.db)
            .join(Metadata.self, on: \BlogPostModel.$id == \Metadata.$reference, method: .inner)
            .filter(Metadata.self, \.$status == .published)
            .sort(Metadata.self, \.$date, .descending)
            .range(..<17)
            .with(\.$category)
            .all()
            .flatMap { posts in
                return req.leaf.render(template: "Blog/Frontend/Home", context: [
                    "posts": .array(posts.map { $0.joinedMetadata() }.map(\.leafData))
                ])
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

        return items.and(count).map { (posts, count) -> ViewKit.Page<LeafData> in
            let total = Int(ceil(Float(count) / Float(limit)))
            return .init(posts.map { $0.joinedMetadata() }, info: .init(current: page, limit: limit, total: total))
        }
        .flatMap { req.leaf.render(template: "Blog/Frontend/Posts", context: ["list": $0.leafData]) }
        .encodeResponse(for: req)
    }
    
    func categoriesView(req: Request, page content: Metadata) throws -> EventLoopFuture<Response> {
        BlogCategoryModel
            .findMetadata(on: req.db)
            .filter(Metadata.self, \.$status == .published)
            .all()
            .flatMap { categories in
                req.leaf.render(template: "Blog/Frontend/Categories", context: [
                    "categories": .array(categories.map { $0.joinedMetadata() }.map(\.leafData))
                ])
            }
            .encodeResponse(for: req)
    }
    
    func authorsView(req: Request, page content: Metadata) throws -> EventLoopFuture<Response> {
        BlogAuthorModel
            .findMetadata(on: req.db)
            .filter(Metadata.self, \.$status == .published)
            .all()
            .flatMap { authors in
                req.leaf.render(template: "Blog/Frontend/Authors", context: [
                    "authors": .array(authors.map { $0.joinedMetadata() }.map(\.leafData))
                ])
            }
            .encodeResponse(for: req)
    }
    
    
    
    func categoryView(_ req: Request, _ metadata: Metadata) -> EventLoopFuture<View> {
        BlogPostModel.findMetadata(on: req.db)
        .filter(\.$category.$id == metadata.reference)
        .all()
        .and(
            BlogCategoryModel
                .find(metadata.reference, on: req.db)
                .unwrap(or: Abort(.notFound))
        )
        .flatMap { posts, category in
            req.leaf.render(template: "Blog/Frontend/Category", context: [
                "category": category.leafData,
                "posts": .array(posts.map { $0.joinedMetadata() })
            ])
        }
    }
    
    func authorView(_ req: Request, _ metadata: Metadata) -> EventLoopFuture<View> {
        BlogPostModel
            .findMetadata(on: req.db)
            .filter(\.$author.$id == metadata.reference)
            .with(\.$category)
            .all()
            .and(
                BlogAuthorModel
                    .query(on: req.db)
                    .filter(\.$id == metadata.reference)
                    .with(\.$links)
                    .first()
                    .unwrap(or: Abort(.notFound))
            )
            .flatMap { posts, author in
                req.leaf.render(template: "Blog/Frontend/Author", context: [
                    "author": author.leafData,
                    "posts": .array(posts.map { $0.joinedMetadata() }),
                ])
            }
    }
    
    func postView(_ req: Request, _ metadata: Metadata) -> EventLoopFuture<View> {
        BlogPostModel
            .findMetadata(on: req.db)
            .filter(\.$id == metadata.reference)
            .with(\.$category)
            .with(\.$author) { $0.with(\.$links) }
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMap { req.leaf.render(template: "Blog/Frontend/Post", context: ["post": $0.joinedMetadata()]) }
    }
}
