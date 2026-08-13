//
//  TagDatabaseRepository.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

import BlogDomain
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import WebDomain
import WebInfrastructure

extension TagTable.Row {
    func asDomain(
        metadata: Metadata
    ) -> Tag {
        .init(
            id: id,
            title: title,
            excerpt: excerpt,
            content: content,
            imageAssetId: imageAssetId,
            metadata: metadata,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct TagDatabaseRepository: TagRepository {

    public let context: DatabaseTransactionContext
    public init(context: DatabaseTransactionContext) {
        self.context = context
    }

    public func insert(
        _ model: Tag.New
    ) async throws -> Tag {
        let table = TagTable(connection: context.connection)
        let saved = try await table.create(
            row: .init(
                id: context.idGenerator.generate(),
                title: model.title,
                excerpt: model.excerpt,
                content: model.content,
                imageAssetId: model.imageAssetId
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
    ) async throws -> Tag? {
        let table = TagTable(connection: context.connection)
        guard let tag = try await table.find(id: id) else { return nil }
        guard
            let metadata = try await MetadataDatabaseRepository(
                context: context
            )
            .find(
                reference: .existing(.init(type: "blog.tag", id: id))
            )
        else { return nil }
        return tag.asDomain(metadata: metadata)
    }

    public func update(
        _ model: Tag
    ) async throws -> Tag {
        let table = TagTable(connection: context.connection)
        let updated = try await table.update(
            id: model.id,
            row: .init(
                id: model.id,
                title: model.title,
                excerpt: model.excerpt,
                content: model.content,
                imageAssetId: model.imageAssetId,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt
            )
        )
        return updated.asDomain(metadata: model.metadata)
    }

    public func delete(
        id: String
    ) async throws -> Bool {
        let table = TagTable(connection: context.connection)
        return try await table.delete(id: id)
    }
}
