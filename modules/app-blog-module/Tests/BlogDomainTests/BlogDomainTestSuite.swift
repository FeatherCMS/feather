//
//  BlogDomainTestSuite.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 07. 16.

import Testing
import WebDomain

@testable import BlogDomain

@Suite
struct BlogDomainTestSuite {

    @Test
    func moduleIsReadyForDomainFeatures() {
        _ = Author.self
    }

    @Test
    func tagCreateBuildsMetadataFromTitle() throws {
        let tag = try Tag.create(
            title: "Swift News",
            excerpt: "Updates",
            content: "Content"
        )

        #expect(tag.title == "Swift News")
        #expect(tag.metadata.slug == "swift-news")
    }

    @Test
    func authorRejectsEmptyName() {
        #expect(throws: Author.Error.nameTooShort) {
            try Author.create(
                name: "",
                excerpt: "About",
                content: "Content"
            )
        }
    }
}
