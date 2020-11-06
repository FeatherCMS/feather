//
//  BlogModule+Install.swift
//  Feather
//
//  Created by Tibor Bodecs on 2020. 07. 12..
//

import Vapor
import Fluent
import Liquid
import FeatherCore

extension BlogModule {
    
    func installHook(req: Request) -> EventLoopFuture<Any?>? {
        req.eventLoop.flatten([
            req.variables.set("posts.page.title", value: "Posts page title"),
            req.variables.set("posts.page.description", value: "Posts page description"),
            req.variables.set("categories.page.title", value: "Categories page title"),
            req.variables.set("categories.page.description", value: "Categories page description"),
            req.variables.set("authors.page.title", value: "Authors page title"),
            req.variables.set("authors.page.description", value: "Authors page description"),
            installSampleContent(req)
        ])
        .map { $0 as Any }
    }

    func installSampleContent(_ req: Request) -> EventLoopFuture<Void> {
        return req.eventLoop.future()
        try! FileManager.default.createDirectory(atPath: Application.Paths.assets + "blog/posts",
                                                withIntermediateDirectories: true,
                                                attributes: [.posixPermissions: 0o744])
        try! FileManager.default.createDirectory(atPath: Application.Paths.assets + "blog/authors",
                                                withIntermediateDirectories: true,
                                                attributes: [.posixPermissions: 0o744])
        try! FileManager.default.createDirectory(atPath: Application.Paths.assets + "blog/categories",
                                                withIntermediateDirectories: true,
                                                attributes: [.posixPermissions: 0o744])

        let c1id = UUID()
        let cf1 = Application.Paths.resources + "Sample/Media/Category.jpg"
        let ct1 = Application.Paths.assets + "blog/categories/\(c1id.uuidString).jpg"
        try! FileManager.default.copyItem(atPath: cf1, toPath: ct1)
        let c1 = BlogCategoryModel(id: c1id,
                                   title: "Getting started",
                                   imageKey: "blog/categories/\(c1id.uuidString).jpg",
                                   excerpt: "Lorem ipsum dolor sit amet")
        
        let a1id = UUID()
        let af1 = Application.Paths.resources + "Sample/Media/Author.jpg"
        let at1 = Application.Paths.assets + "blog/authors/\(a1id.uuidString).jpg"
        try! FileManager.default.copyItem(atPath: af1, toPath: at1)
        let a1 = BlogAuthorModel(id: a1id,
                                 name: "Feather",
                                 imageKey: "blog/authors/\(a1id.uuidString).jpg",
                                 bio: "Feather is a modern Swift-based CMS powered by Vapor 4.")
        
        
        let p1id = UUID()
        let f1 = Application.Paths.resources + "Sample/Media/01.jpg"
        let t1 = Application.Paths.assets + "blog/posts/\(p1id.uuidString).jpg"
        try! FileManager.default.copyItem(atPath: f1, toPath: t1)
        let b1 = try! String(contentsOfFile: Application.Paths.resources + "Sample/Content/WelcomePost.html")
        let p1 = BlogPostModel(id: p1id,
                           title: "Welcome to Feather",
                           imageKey: "blog/posts/\(p1id.uuidString).jpg",
                           excerpt: "Feather is a modern Swift-based CMS powered by Vapor 4.",
                           content: b1,
                           categoryId: c1.id!,
                           authorId: a1.id!)
        
        let p2id = UUID()
        let f2 = Application.Paths.resources + "Sample/Media/02.jpg"
        let t2 = Application.Paths.assets + "blog/posts/\(p2id.uuidString).jpg"
        try! FileManager.default.copyItem(atPath: f2, toPath: t2)
        let p2 = BlogPostModel(id: p2id,
                           title: "Getting started",
                           imageKey: "blog/posts/\(p2id.uuidString).jpg",
                           excerpt: "Curabitur nunc lectus, mollis nec odio nec, pulvinar semper est.",
                           content: "<section><h2>This is the very first content</h2></section>",
                           categoryId: c1.id!,
                           authorId: a1.id!)
        
        let p3id = UUID()
        let f3 = Application.Paths.resources + "Sample/Media/03.jpg"
        let t3 = Application.Paths.assets + "blog/posts/\(p3id.uuidString).jpg"
        try! FileManager.default.copyItem(atPath: f3, toPath: t3)
        let p3 = BlogPostModel(id: p3id,
                           title: "A modular blog engine",
                           imageKey: "blog/posts/\(p3id.uuidString).jpg",
                           excerpt: "Nullam ut augue pellentesque, elementum ex in, consectetur velit. Maecenas at risus tortor.",
                           content: "<section><h2>This is the very first content</h2></section>",
                           categoryId: c1.id!,
                           authorId: a1.id!)
        
        let p4id = UUID()
        let f4 = Application.Paths.resources + "Sample/Media/04.jpg"
        let t4 = Application.Paths.assets + "blog/posts/\(p4id.uuidString).jpg"
        try! FileManager.default.copyItem(atPath: f4, toPath: t4)
        let p4 = BlogPostModel(id: p4id,
                           title: "Learn the basics",
                           imageKey: "blog/posts/\(p4id.uuidString).jpg",
                           excerpt: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse scelerisque tincidunt ullamcorper.",
                           content: "<section><h2>This is the very first content</h2></section>",
                           categoryId: c1.id!,
                           authorId: a1.id!)
        
        let p5id = UUID()
        let f5 = Application.Paths.resources + "Sample/Media/05.jpg"
        let t5 = Application.Paths.assets + "blog/posts/\(p5id.uuidString).jpg"
        try! FileManager.default.copyItem(atPath: f5, toPath: t5)
        let p5 = BlogPostModel(id: p5id,
                           title: "Posts and pages",
                           imageKey: "blog/posts/\(p5id.uuidString).jpg",
                           excerpt: "Suspendisse potenti. Donec dignissim nibh non nisi finibus luctus.",
                           content: "<section><h2>This is the very first content</h2></section>",
                           categoryId: c1.id!,
                           authorId: a1.id!)
        
        let now = Date()

        return req.db.eventLoop.flatten([
            [c1].create(on: req.db),
            try! c1.updateMetadata(on: req.db) { content in
                content.status = .published
                content.date = now
            },
            [a1].create(on: req.db),
            try! a1.updateMetadata(on: req.db) { content in
                content.status = .published
                content.date = now
            },
            [p1, p2, p3, p4, p5].create(on: req.db),
            try! p1.updateMetadata(on: req.db) { content in
                content.status = .published
                content.date = now
            },
            try! p2.updateMetadata(on: req.db) { content in
                content.status = .published
                content.date = Date(timeInterval: -1*86400, since: now)
            },
            try! p3.updateMetadata(on: req.db) { content in
                content.status = .published
                content.date = Date(timeInterval: -2*86400, since: now)
            },
            try! p4.updateMetadata(on: req.db) { content in
                content.status = .published
                content.date = Date(timeInterval: -3*86400, since: now)
            },
            try! p5.updateMetadata(on: req.db) { content in
                content.status = .published
                content.date = Date(timeInterval: -4*86400, since: now)
            },
        ])
    }
}
