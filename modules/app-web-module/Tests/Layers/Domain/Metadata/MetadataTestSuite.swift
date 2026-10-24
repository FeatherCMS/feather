//
//  MetadataTestSuite.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 07. 16.

import FeatherDomain
import Testing
import WebModule

import struct Foundation.Date

@testable import WebDomain

@Suite
struct MetadataTestSuite {

    @Test
    func createSucceedsWithValidInput() throws {
        let result = try Metadata.Model.create(
            reference: .type("page"),
            template: "default",
            slug: "home",
            publicationDate: .distantPast,
            expirationDate: nil,
            status: .draft,
            title: "Home",
            excerpt: nil,
            imageURL: nil,
            canonicalURL: "",
            noIndex: false,
            primaryKeyword: "",
            cssCodeInjection: "",
            javascriptCodeInjection: "",
            structuredDataCodeInjection: ""
        )

        #expect(result.slug == "home")
        #expect(result.status == .draft)
    }

    @Test
    func createRejectsEmptySlug() {
        #expect(throws: Metadata.Model.Error.slugTooShort) {
            try Metadata.Model.create(
                reference: .type("page"),
                template: "default",
                slug: "",
                publicationDate: .distantPast,
                expirationDate: nil,
                status: .draft,
                title: nil,
                excerpt: nil,
                imageURL: nil,
                canonicalURL: "",
                noIndex: false,
                primaryKeyword: "",
                cssCodeInjection: "",
                javascriptCodeInjection: "",
                structuredDataCodeInjection: ""
            )
        }
    }

    @Test
    func updateChangesProvidedValues() throws {
        var metadata = Metadata.Model(
            id: "metadata-1",
            reference: .identified(.init(type: "page", id: "page-1")),
            template: "default",
            slug: "home",
            publicationDate: .distantPast,
            expirationDate: nil,
            status: .draft,
            title: nil,
            excerpt: nil,
            imageURL: nil,
            canonicalURL: "",
            noIndex: false,
            primaryKeyword: "",
            cssCodeInjection: "",
            javascriptCodeInjection: "",
            structuredDataCodeInjection: "",
            createdAt: .distantPast,
            updatedAt: Date()
        )

        try metadata.update(slug: .set("about"), status: .set(.published))

        #expect(metadata.slug == "about")
        #expect(metadata.status == .published)
    }

    @Test
    func updateClearsImageURLWhenEmptyValueIsProvided() throws {
        var metadata = Metadata.Model(
            id: "metadata-1",
            reference: .identified(.init(type: "page", id: "page-1")),
            template: "default",
            slug: "home",
            publicationDate: .distantPast,
            expirationDate: nil,
            status: .draft,
            title: nil,
            excerpt: nil,
            imageURL: "/public/12/34/56789/originals/image.jpg",
            canonicalURL: "",
            noIndex: false,
            primaryKeyword: "",
            cssCodeInjection: "",
            javascriptCodeInjection: "",
            structuredDataCodeInjection: "",
            createdAt: .distantPast,
            updatedAt: Date()
        )

        try metadata.update(imageURL: .set(""))

        #expect(metadata.imageURL == nil)
    }
}
