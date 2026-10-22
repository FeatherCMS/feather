//
//  Post.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import BlogModule
public import FeatherDomain
import FeatherModuleKit
public import WebDomain

public import struct Foundation.Date

extension Post {
    public struct Model: FeatherDomain.Model {

        public enum Error: DomainError {
            case titleTooShort
            case titleTooLong
            case excerptTooLong
            case contentTooLong
        }

        public struct New: Sendable {
            public let title: String
            public let excerpt: String
            public let content: String
            public let imageAssetId: String?
            public let authorIds: [String]
            public let tagIds: [String]
            public let metadata: WebDomain.Metadata.Model.New
        }

        public let id: String
        public var title: String
        public var excerpt: String
        public var content: String
        public var imageAssetId: String?
        public var authorIds: [String]
        public var tagIds: [String]
        public var metadata: WebDomain.Metadata.Model
        public let createdAt: Date
        public let updatedAt: Date

        package init(
            id: String,
            title: String,
            excerpt: String,
            content: String,
            imageAssetId: String?,
            authorIds: [String],
            tagIds: [String],
            metadata: WebDomain.Metadata.Model,
            createdAt: Date,
            updatedAt: Date
        ) {
            self.id = id
            self.title = title
            self.excerpt = excerpt
            self.content = content
            self.imageAssetId = imageAssetId
            self.authorIds = authorIds
            self.tagIds = tagIds
            self.metadata = metadata
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
    }
    }

    extension Post.Model {

    private static func validate(
        title: String
    ) throws(Self.Error) {
        guard !title.isEmpty else {
            throw .titleTooShort
        }
        guard title.count < 255 else {
            throw .titleTooLong
        }
    }

    private static func validate(
        excerpt: String
    ) throws(Self.Error) {
        guard excerpt.count < 4_000 else {
            throw .excerptTooLong
        }
    }

    private static func validate(
        content: String
    ) throws(Self.Error) {
        guard content.count < 200_000 else {
            throw .contentTooLong
        }
    }

    public static func create(
        title: String,
        excerpt: String,
        content: String,
        imageAssetId: String? = nil,
        authorIds: [String],
        tagIds: [String],
        metadata: WebDomain.Metadata.Model.Base? = nil
    ) throws -> Self.New {
        try validate(title: title)
        try validate(excerpt: excerpt)
        try validate(content: content)

        let metadataModel = try WebDomain.Metadata.Model.create(
            reference: .type("blog.post"),
            base: metadata
                ?? .init(
                    template: "blog.post",
                    slug: title.slugified
                )
        )

        return .init(
            title: title,
            excerpt: excerpt,
            content: content,
            imageAssetId: imageAssetId,
            authorIds: authorIds,
            tagIds: tagIds,
            metadata: metadataModel
        )
    }

    public mutating func update(
        title: FieldChange<String>,
        excerpt: FieldChange<String>,
        content: FieldChange<String>,
        imageAssetId: OptionalFieldChange<String>,
        authorIds: FieldChange<[String]>,
        tagIds: FieldChange<[String]>
    ) throws(Self.Error) {
        let newTitle = title.apply(to: self.title)
        let newExcerpt = excerpt.apply(to: self.excerpt)
        let newContent = content.apply(to: self.content)

        try Self.validate(title: newTitle)
        try Self.validate(excerpt: newExcerpt)
        try Self.validate(content: newContent)

        self.title = newTitle
        self.excerpt = newExcerpt
        self.content = newContent
        self.imageAssetId = imageAssetId.apply(to: self.imageAssetId)
        self.authorIds = authorIds.apply(to: self.authorIds)
        self.tagIds = tagIds.apply(to: self.tagIds)
    }
}
