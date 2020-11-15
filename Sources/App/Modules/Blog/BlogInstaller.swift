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
            BlogPostModel(title: "Binary Birds",
                          imageKey: "blog/posts/0ff020a2-3977-484d-b636-11348a67b4f7.jpg",
                          excerpt: "Feather is a modern Swift-based CMS powered by Vapor 4.",
                          content: BlogModule.sample(asset: "binary-birds.html"),
                          categoryId: categoryId,
                          authorId: authorId),
            BlogPostModel(title: "Feather API",
                          imageKey: "blog/posts/010d620f-424c-4a3a-ac6b-f635486052de.jpg",
                          excerpt: "This post is a showcase about the available content blocks.",
                          content: BlogModule.sample(asset: "api.html"),
                          categoryId: categoryId,
                          authorId: authorId),
            BlogPostModel(title: "Bring your own theme",
                          imageKey: "blog/posts/30ca164c-a9e5-40f8-9daa-ffcb4c7ffea8.jpg",
                          excerpt: "You can build your own themes using HTML & CSS and Tau.",
                          content: BlogModule.sample(asset: "themes.html"),
                          categoryId: categoryId,
                          authorId: authorId),
            BlogPostModel(title: "Shortcodes and filters",
                          imageKey: "blog/posts/87da5c18-5013-4672-bd52-487734550723.jpg",
                          excerpt: "Suspendisse potenti. Donec dignissim nibh non nisi finibus luctus.",
                          content: BlogModule.sample(asset: "filters.html"),
                          categoryId: categoryId,
                          authorId: authorId),
            BlogPostModel(title: "Content and metadata",
                          imageKey: "blog/posts/636c4b1a-b280-4da3-9e7a-24538858df4a.jpg",
                          excerpt: "Suspendisse potenti. Donec dignissim nibh non nisi finibus luctus.",
                          content: BlogModule.sample(asset: "metadata.html"),
                          categoryId: categoryId,
                          authorId: authorId),
            BlogPostModel(title: "Static pages",
                          imageKey: "blog/posts/1878d3af-d41a-4177-88d5-6689117cf917.jpg",
                          excerpt: "Suspendisse potenti. Donec dignissim nibh non nisi finibus luctus.",
                          content: BlogModule.sample(asset: "pages.html"),
                          categoryId: categoryId,
                          authorId: authorId),
            BlogPostModel(title: "Writing blog posts",
                          imageKey: "blog/posts/2045c4eb-cf11-4242-beda-7902b325a564.jpg",
                          excerpt: "Suspendisse potenti. Donec dignissim nibh non nisi finibus luctus.",
                          content: BlogModule.sample(asset: "posts.html"),
                          categoryId: categoryId,
                          authorId: authorId),
            BlogPostModel(title: "Branding your site",
                          imageKey: "blog/posts/60676325-ce03-495d-a098-0780c59a4e3a.jpg",
                          excerpt: "Suspendisse potenti. Donec dignissim nibh non nisi finibus luctus.",
                          content: BlogModule.sample(asset: "brand.html"),
                          categoryId: categoryId,
                          authorId: authorId),
            BlogPostModel(title: "A quick tour",
                          imageKey: "blog/posts/e44dd240-b702-47d8-8be3-fac2265d128a.jpg",
                          excerpt: "Suspendisse potenti. Donec dignissim nibh non nisi finibus luctus.",
                          content: BlogModule.sample(asset: "tour.html"),
                          categoryId: categoryId,
                          authorId: authorId),
            BlogPostModel(title: "Welcome to Feather",
                          imageKey: "blog/posts/eb03ed0a-c5e1-48ae-8f9f-f3ac482e5fa4.jpg",
                          excerpt: "Suspendisse potenti. Donec dignissim nibh non nisi finibus luctus.",
                          content: BlogModule.sample(asset: "welcome.html"),
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
