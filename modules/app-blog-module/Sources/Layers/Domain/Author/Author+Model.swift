//
//  Author.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import BlogModule
public import FeatherDomain
import FeatherModuleKit
public import WebDomain
public import WebModule

public import struct Foundation.Date

extension Author {
    public struct Model: FeatherDomain.Model {

        public enum Error: DomainError {
            case nameTooShort
            case nameTooLong
            case excerptTooLong
            case contentTooLong
        }

        public struct New: Sendable {
            public let name: String
            public let excerpt: String
            public let content: String
            public let profileImageAssetId: String?
            public let metadata: WebModule.Metadata.Model.New
        }

        public let id: String
        public var name: String
        public var excerpt: String
        public var content: String
        public var profileImageAssetId: String?
        public var metadata: WebModule.Metadata.Model
        public let createdAt: Date
        public let updatedAt: Date

        package init(
            id: String,
            name: String,
            excerpt: String,
            content: String,
            profileImageAssetId: String?,
            metadata: WebModule.Metadata.Model,
            createdAt: Date,
            updatedAt: Date
        ) {
            self.id = id
            self.name = name
            self.excerpt = excerpt
            self.content = content
            self.profileImageAssetId = profileImageAssetId
            self.metadata = metadata
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
    }
}

extension Author.Model {

    private static func validate(
        name: String
    ) throws(Self.Error) {
        guard !name.isEmpty else {
            throw .nameTooShort
        }
        guard name.count < 255 else {
            throw .nameTooLong
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
        name: String,
        excerpt: String,
        content: String,
        profileImageAssetId: String? = nil,
        metadata: WebModule.Metadata.Model.Base? = nil
    ) throws -> Self.New {
        try validate(name: name)
        try validate(excerpt: excerpt)
        try validate(content: content)

        let metadataModel = try WebModule.Metadata.Model.create(
            reference: .type("blog.author"),
            base: metadata
                ?? .init(
                    template: "blog.author",
                    slug: name.slugified
                )
        )

        return .init(
            name: name,
            excerpt: excerpt,
            content: content,
            profileImageAssetId: profileImageAssetId,
            metadata: metadataModel
        )
    }

    public mutating func update(
        name: FieldChange<String>,
        excerpt: FieldChange<String>,
        content: FieldChange<String>,
        profileImageAssetId: OptionalFieldChange<String>
    ) throws(Self.Error) {
        let newName = name.apply(to: self.name)
        let newExcerpt = excerpt.apply(to: self.excerpt)
        let newContent = content.apply(to: self.content)
        let newProfileImageAssetId = profileImageAssetId.apply(
            to: self.profileImageAssetId
        )

        try Self.validate(name: newName)
        try Self.validate(excerpt: newExcerpt)
        try Self.validate(content: newContent)

        self.name = newName
        self.excerpt = newExcerpt
        self.content = newContent
        self.profileImageAssetId = newProfileImageAssetId
    }
}
