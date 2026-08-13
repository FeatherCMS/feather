//
//  PostDatabaseRepository.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

import BlogDomain
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import WebDomain
import WebInfrastructure

extension PostTable.Row {
    func asDomain(
        metadata: Metadata
    ) -> Post {
        .init(
            id: id,
            title: title,
            excerpt: excerpt,
            content: content,
            imageAssetId: imageAssetId,
            authorIds: authorIds,
            tagIds: tagIds,
            metadata: metadata,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct PostDatabaseRepository: PostRepository {

    public let context: DatabaseTransactionContext
    public init(context: DatabaseTransactionContext) {
        self.context = context
    }

    public func insert(
        _ model: Post.New
    ) async throws -> Post {
        let table = PostTable(connection: context.connection)
        let saved = try await table.create(
            row: .init(
                id: context.idGenerator.generate(),
                title: model.title,
                excerpt: model.excerpt,
                content: model.content,
                imageAssetId: model.imageAssetId,
                authorIds: model.authorIds,
                tagIds: model.tagIds
            )
        )
        var newMetadata = model.metadata
        try newMetadata.set(referenceID: saved.id)
        let metadata = try await MetadataDatabaseRepository(context: context)
            .insert(newMetadata)
        return saved.asDomain(metadata: metadata)
    }

    public func find(
        id: String
    ) async throws -> Post? {
        let table = PostTable(connection: context.connection)
        guard let post = try await table.find(id: id) else { return nil }
        guard
            let metadata = try await MetadataDatabaseRepository(
                context: context
            )
            .find(
                reference: .existing(.init(type: "blog.post", id: id))
            )
        else { return nil }
        return post.asDomain(metadata: metadata)
    }

    public func update(
        _ model: Post
    ) async throws -> Post {
        let table = PostTable(connection: context.connection)
        let updated = try await table.update(
            id: model.id,
            row: .init(
                id: model.id,
                title: model.title,
                excerpt: model.excerpt,
                content: model.content,
                imageAssetId: model.imageAssetId,
                authorIds: model.authorIds,
                tagIds: model.tagIds,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt
            )
        )
        return updated.asDomain(metadata: model.metadata)
    }

    public func removeAuthor(
        id: String
    ) async throws {
        let table = PostTable(connection: context.connection)
        try await table.removeAuthorReference(id: id)
    }

    public func removeTag(
        id: String
    ) async throws {
        let table = PostTable(connection: context.connection)
        try await table.removeTagReference(id: id)
    }

    public func delete(
        id: String
    ) async throws -> Bool {
        let table = PostTable(connection: context.connection)
        return try await table.delete(id: id)
    }
}
