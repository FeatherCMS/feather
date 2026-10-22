//
//  Category.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherDomain
import FeatherModuleKit
public import NewsModule
public import Foundation
public import WebDomain

public import struct Foundation.Date

extension NewsModule.Category {
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
        public let metadata: WebDomain.Metadata.Model.New
    }

    public let id: String
    public var title: String
    public var excerpt: String
    public var content: String
    public var imageAssetId: String?
    public var metadata: WebDomain.Metadata.Model
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        title: String,
        excerpt: String,
        content: String,
        imageAssetId: String?,
        metadata: WebDomain.Metadata.Model,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.title = title
        self.excerpt = excerpt
        self.content = content
        self.imageAssetId = imageAssetId
        self.metadata = metadata
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    }
}

extension NewsModule.Category.Model {

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
        metadata: WebDomain.Metadata.Model.Base? = nil
    ) throws -> Self.New {
        try validate(title: title)
        try validate(excerpt: excerpt)
        try validate(content: content)

        let metadataModel = try WebDomain.Metadata.Model.create(
            reference: .type("news.category"),
            base: metadata
                ?? .init(
                    template: "news.category",
                    slug: title.slugified
                )
        )

        return .init(
            title: title,
            excerpt: excerpt,
            content: content,
            imageAssetId: imageAssetId,
            metadata: metadataModel
        )
    }

    public mutating func update(
        title: String? = nil,
        excerpt: String? = nil,
        content: String? = nil,
        imageAssetId: String?? = nil
    ) throws(Self.Error) {
        let newTitle = title ?? self.title
        let newExcerpt = excerpt ?? self.excerpt
        let newContent = content ?? self.content

        try Self.validate(title: newTitle)
        try Self.validate(excerpt: newExcerpt)
        try Self.validate(content: newContent)

        self.title = newTitle
        self.excerpt = newExcerpt
        self.content = newContent
        self.imageAssetId = imageAssetId ?? self.imageAssetId
    }
}
