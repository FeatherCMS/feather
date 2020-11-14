//
//  BlogInstaller.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 07. 12..
//

import FeatherCore

struct BlogInstaller: ViperInstaller {

    /// returns the blog related dictionary of variables
    func variables() -> [[String: Any]] {
        [
            [
                "key": "posts.page.title",
                "value": "Posts page title",
                "note": "Title of the posts page",
            ],
            [
                "key": "posts.page.description",
                "value": "Posts page description",
                "note": "Description of the posts page",
            ],
            [
                "key": "categories.page.title",
                "value": "Categories page title",
                "note": "Title of the categories page",
            ],
            [
                "key": "categories.page.description",
                "value": "Categories page description",
                "note": "Description of the posts page",
            ],
            [
                "key": "authors.page.title",
                "value": "Authors page title",
                "note": "Title of the authors page",
            ],
            [
                "key": "authors.page.description",
                "value": "Authors page description",
                "note": "Description of the authors page",
            ],
        ]
    }
    
    /// create blog related sample models
    func createModels(_ req: Request) -> EventLoopFuture<Void>? {
        /// we need a fixed category id & a sample category first
        let categoryId = UUID()
        let category = BlogCategoryModel(id: categoryId,
                          title: "Getting started",
                          imageKey: "blog/categories/d24868b4-b264-492e-845d-16ed11582cc7.jpg",
                          excerpt: "Lorem ipsum dolor sit amet")
        
        /// we also need a fixed author id & a sample author
        let authorId = UUID()
        let author = BlogAuthorModel(id: authorId,
                        name: "Feather",
                        imageKey: "blog/authors/0e239e14-1499-44f3-bb46-3be7ea3a099d.jpg",
                        bio: "Feather is a modern Swift-based CMS powered by Vapor 4.")

        /// we will use some sample posts
        let posts = [
            BlogPostModel(title: "Welcome to Feather",
                          imageKey: "blog/posts/636c4b1a-b280-4da3-9e7a-24538858df4a.jpg",
                          excerpt: "Feather is a modern Swift-based CMS powered by Vapor 4.",
                          content: "",
                          categoryId: categoryId,
                          authorId: authorId),
            BlogPostModel(title: "Getting started",
                          imageKey: "blog/posts/xxxxxxx.jpg",
                          excerpt: "Curabitur nunc lectus, mollis nec odio nec, pulvinar semper est.",
                          content: "<section><h2>This is the very first content</h2></section>",
                          categoryId: categoryId,
                          authorId: authorId),
            BlogPostModel(title: "Learn the basics",
                          imageKey: "blog/posts/xxxxxxxx.jpg",
                          excerpt: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse scelerisque tincidunt ullamcorper.",
                          content: "<section><h2>This is the very first content</h2></section>",
                          categoryId: categoryId,
                          authorId: authorId),
            BlogPostModel(title: "Posts and pages",
                          imageKey: "blog/posts/xxxxxxxx.jpg",
                          excerpt: "Suspendisse potenti. Donec dignissim nibh non nisi finibus luctus.",
                          content: "<section><h2>This is the very first content</h2></section>",
                          categoryId: categoryId,
                          authorId: authorId),
        ]

        /// we persist the category, author and posts
        return req.eventLoop.flatten([
            /// save category, then publish associated metadata
            category.create(on: req.db).flatMap { category.publishMetadata(on: req.db) },
            /// save author, then publish associated metadata
            author.create(on: req.db).flatMap { author.publishMetadata(on: req.db) },
            /// save posts
            posts.create(on: req.db).flatMap { _ in
                /// after the posts are created we publish the associated metadatas
                req.eventLoop.flatten(posts.map { $0.publishMetadata(on: req.db) })
            }
        ])
    }

}
