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

    func home(posts: [BlogPostModel]) -> EventLoopFuture<View> {
        render("home", ["posts": .array(posts.map { $0.joinedMetadata() }.map(\.leafData))])
    }

    func posts(page: ViewKit.Page<LeafData>) -> EventLoopFuture<View> {
        render("posts", ["page": page.leafData])
    }
    
    func categories(_ categories: [BlogCategoryModel]) -> EventLoopFuture<View> {
        render("categories", ["categories": .array(categories.map { $0.joinedMetadata() }.map(\.leafData))])
    }
    
    func category(_ category: BlogCategoryModel, posts: [BlogPostModel]) -> EventLoopFuture<View> {
        render("category", ["category": category.leafData, "posts": .array(posts.map { $0.joinedMetadata() })])
    }
    
    func authors(_ authors: [BlogAuthorModel]) -> EventLoopFuture<View> {
        render("authors", ["authors": .array(authors.map { $0.joinedMetadata() }.map(\.leafData))])
    }

    func author(_ author: BlogAuthorModel, posts: [BlogPostModel]) -> EventLoopFuture<View> {
        render("author", ["author": author.leafData, "posts": .array(posts.map { $0.joinedMetadata() })])
    }
    
    func post(_ post: BlogPostModel) -> EventLoopFuture<View> {
        render("post", ["post": post.joinedMetadata()])
    }
}
