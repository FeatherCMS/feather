//
//  BlogFrontendView.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 11. 06..
//

import FeatherCore

struct BlogFrontendView {

    let name = "frontend"
    
    let req: Request

    init(_ req: Request) {
        self.req = req
    }
    
    private func render(_ name: String, _ context: LeafRenderer.Context) -> EventLoopFuture<View> {
        let template = "\(BlogModule.name.capitalized)/\(self.name.capitalized)/\(name.capitalized)"
        return req.leaf.render(template: template, context: context)
    }

    func home(posts: [BlogPostModel], metadata: Metadata) -> EventLoopFuture<View> {
        render("home", [
                "metadata": metadata.leafData,
                "posts": .array(posts.map { $0.leafDataWithMetadata }.map(\.leafData)),
        ])
    }

    func posts(page: ViewKit.Page<LeafData>, metadata: Metadata) -> EventLoopFuture<View> {
        render("posts", [
                "metadata": metadata.leafData,
                "page": page.leafData,
        ])
    }
    
    func categories(_ categories: [BlogCategoryModel], metadata: Metadata) -> EventLoopFuture<View> {
        render("categories", [
                "metadata": metadata.leafData,
                "categories": .array(categories.map { $0.leafDataWithMetadata }.map(\.leafData)),
        ])
    }
    
    func category(_ category: BlogCategoryModel, posts: [BlogPostModel], metadata: Metadata) -> EventLoopFuture<View> {
        render("category", [
                "metadata": metadata.leafData,
                "category": category.leafData, "posts": .array(posts.map { $0.leafDataWithMetadata }),
        ])
    }
    
    func authors(_ authors: [BlogAuthorModel], metadata: Metadata) -> EventLoopFuture<View> {
        render("authors", [
                "metadata": metadata.leafData,
                "authors": .array(authors.map { $0.leafDataWithMetadata }.map(\.leafData)),
        ])
    }

    func author(_ author: BlogAuthorModel, posts: [BlogPostModel], metadata: Metadata) -> EventLoopFuture<View> {
        render("author", [
                "metadata": metadata.leafData,
                "author": author.leafData,
                "posts": .array(posts.map { $0.leafDataWithMetadata }),
        ])
    }
    
    func post(_ post: BlogPostModel) -> EventLoopFuture<View> {
        render("post", ["post": post.leafDataWithMetadata])
    }
}
