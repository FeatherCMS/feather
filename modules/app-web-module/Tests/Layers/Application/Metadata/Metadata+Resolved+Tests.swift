//
//  Metadata+Resolved+Tests.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 07. 16.

import Testing
import WebDomain
import WebModule

import struct Foundation.Date

@testable import WebApplication

@Suite
struct MetadataResolvedTests {

    @Test
    func usesExplicitMetadataValues() {
        let now = Date()
        let metadata = Metadata.Snapshot(
            id: "metadata-1",
            referenceType: "blog.post",
            referenceID: "post-1",
            template: "default",
            slug: "post-1",
            publicationDate: now,
            expirationDate: nil,
            status: .published,
            title: "Social title",
            excerpt: "Social excerpt",
            imageURL: "/social-image.png",
            canonicalURL: "",
            noIndex: false,
            primaryKeyword: "",
            cssCodeInjection: "",
            javascriptCodeInjection: "",
            structuredDataCodeInjection: "",
            createdAt: now,
            updatedAt: now
        )

        let result = Metadata.Snapshot.Resolved(
            metadata: metadata,
            fallbackTitle: "Fallback title",
            fallbackExcerpt: "Fallback excerpt",
            fallbackImageURL: "/fallback-image.png"
        )

        #expect(result.title == "Social title")
        #expect(result.excerpt == "Social excerpt")
        #expect(result.imageURL == "/social-image.png")
    }

    @Test
    func fallsBackForNilAndEmptyMetadataValues() {
        let now = Date()
        let metadata = Metadata.Snapshot(
            id: "metadata-1",
            referenceType: "blog.post",
            referenceID: "post-1",
            template: "default",
            slug: "post-1",
            publicationDate: now,
            expirationDate: nil,
            status: .published,
            title: "   ",
            excerpt: nil,
            imageURL: "",
            canonicalURL: "",
            noIndex: false,
            primaryKeyword: "",
            cssCodeInjection: "",
            javascriptCodeInjection: "",
            structuredDataCodeInjection: "",
            createdAt: now,
            updatedAt: now
        )

        let result = Metadata.Snapshot.Resolved(
            metadata: metadata,
            fallbackTitle: "Fallback title",
            fallbackExcerpt: "Fallback excerpt",
            fallbackImageURL: "/fallback-image.png"
        )

        #expect(result.title == "Fallback title")
        #expect(result.excerpt == "Fallback excerpt")
        #expect(result.imageURL == "/fallback-image.png")
    }
}
