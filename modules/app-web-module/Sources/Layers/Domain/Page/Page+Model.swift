//
//  Page+Model.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherDomain
import FeatherModuleKit
public import Foundation
public import WebModule

public import struct Foundation.Date

extension Page {
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
            public let metadata: Metadata.Model.New
        }

        public let id: String
        public var title: String
        public var excerpt: String
        public var content: String
        public var imageAssetId: String?
        public var metadata: Metadata.Model
        public let createdAt: Date
        public let updatedAt: Date

        package init(
            id: String,
            title: String,
            excerpt: String,
            content: String,
            imageAssetId: String?,
            metadata: Metadata.Model,
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

extension Page.Model {

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
        metadata: Metadata.Model.Base? = nil
    ) throws -> Self.New {
        try validate(title: title)
        try validate(excerpt: excerpt)
        try validate(content: content)

        let metadataModel = try Metadata.Model.create(
            reference: .type("web.page"),
            base: metadata
                ?? .init(
                    template: "default",
                    slug: title.slugified,
                    status: .published
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
        title: FieldChange<String> = .unchanged,
        excerpt: FieldChange<String> = .unchanged,
        content: FieldChange<String> = .unchanged,
        imageAssetId: OptionalFieldChange<String> = .unchanged
    ) throws(Self.Error) {
        let newTitle = title.apply(to: self.title)
        let newExcerpt = excerpt.apply(to: self.excerpt)
        let newContent = content.apply(to: self.content)
        let newImageAssetId = imageAssetId.apply(to: self.imageAssetId)

        try Self.validate(title: newTitle)
        try Self.validate(excerpt: newExcerpt)
        try Self.validate(content: newContent)

        self.title = newTitle
        self.excerpt = newExcerpt
        self.content = newContent
        self.imageAssetId = newImageAssetId?.emptyToNil
    }
}
