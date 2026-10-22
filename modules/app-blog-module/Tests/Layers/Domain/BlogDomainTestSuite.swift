//
//  BlogDomainTestSuite.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 07. 16.

import BlogModule
import Testing
import WebDomain

@testable import BlogDomain

@Suite
struct BlogDomainTestSuite {

    @Test
    func domainModelsAreNamespaced() {
        _ = Author.Model.self
    }

    @Test
    func tagCreateBuildsMetadataFromTitle() throws {
        let tag = try Tag.Model.create(
            title: "Swift News",
            excerpt: "Updates",
            content: "Content"
        )

        #expect(tag.title == "Swift News")
        #expect(tag.metadata.slug == "swift-news")
    }

    @Test
    func authorRejectsEmptyName() {
        #expect(throws: Author.Model.Error.nameTooShort) {
            try Author.Model.create(
                name: "",
                excerpt: "About",
                content: "Content"
            )
        }
    }

    @Test
    func postCreateBuildsSlugAndRejectsEmptyTitle() throws {
        let post = try Post.Model.create(
            title: "Swift Module News",
            excerpt: "Updates",
            content: "Content",
            authorIds: [],
            tagIds: []
        )

        #expect(post.metadata.slug == "swift-module-news")
        #expect(throws: Post.Model.Error.titleTooShort) {
            try Post.Model.create(
                title: "",
                excerpt: "Updates",
                content: "Content",
                authorIds: [],
                tagIds: []
            )
        }
    }

    @Test
    func authorCreateBuildsSlugAndValues() throws {
        let created = try Author.Model.create(
            name: "Ada Lovelace",
            excerpt: "Mathematician",
            content: "Biography"
        )

        #expect(created.name == "Ada Lovelace")
        #expect(created.metadata.slug == "ada-lovelace")
    }
}
