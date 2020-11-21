//
//  BlogFrontendController.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 03. 27..
//

import Fluent
import FeatherCore

struct BlogFrontendController {

    /// single category page
    func categoryView(_ req: Request, _ metadata: Metadata) -> EventLoopFuture<View> {
        BlogCategoryModel
            .findBy(id: metadata.reference, on: req)
            .and(BlogPostModel.findByCategory(id: metadata.reference, on: req))
            .flatMap { BlogFrontendView(req).category($0, posts: $1, metadata: metadata) }
    }

    /// author profile page
    func authorView(_ req: Request, _ metadata: Metadata) -> EventLoopFuture<View> {
        BlogAuthorModel
            .findBy(id: metadata.reference, on: req)
            .and(BlogPostModel.findByAuthor(id: metadata.reference, on: req))
            .flatMap { BlogFrontendView(req).author($0, posts: $1, metadata: metadata) }
    }

    /// single post page
    func postView(_ req: Request, _ metadata: Metadata) -> EventLoopFuture<View> {
        BlogPostModel
            .findBy(id: metadata.reference, on: req)
            .flatMap { BlogFrontendView(req).post($0) }
    }
}
