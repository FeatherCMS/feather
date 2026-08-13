//
//  AuthorDatabaseRepository.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

import BlogDomain
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import WebDomain
import WebInfrastructure

extension AuthorTable.Row {
    func asDomain(
        metadata: Metadata
    ) -> Author {
        .init(
            id: id,
            name: name,
            excerpt: excerpt,
            content: content,
            profileImageAssetId: profileImageAssetId,
            metadata: metadata,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct AuthorDatabaseRepository: AuthorRepository {

    public let context: DatabaseTransactionContext
    public init(context: DatabaseTransactionContext) {
        self.context = context
    }

    public func insert(
        _ model: Author.New
    ) async throws -> Author {
        let table = AuthorTable(connection: context.connection)
        let saved = try await table.create(
            row: .init(
                id: context.idGenerator.generate(),
                name: model.name,
                excerpt: model.excerpt,
                content: model.content,
                profileImageAssetId: model.profileImageAssetId
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
    ) async throws -> Author? {
        let table = AuthorTable(connection: context.connection)
        guard let author = try await table.find(id: id) else { return nil }
        guard
            let metadata = try await MetadataDatabaseRepository(
                context: context
            )
            .find(
                reference: .existing(.init(type: "blog.author", id: id))
            )
        else { return nil }
        return author.asDomain(metadata: metadata)
    }

    public func update(
        _ model: Author
    ) async throws -> Author {
        let table = AuthorTable(connection: context.connection)
        let updated = try await table.update(
            id: model.id,
            row: .init(
                id: model.id,
                key: model.id,
                name: model.name,
                excerpt: model.excerpt,
                content: model.content,
                profileImageAssetId: model.profileImageAssetId,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt
            )
        )
        return updated.asDomain(metadata: model.metadata)
    }

    public func delete(
        id: String
    ) async throws -> Bool {
        let table = AuthorTable(connection: context.connection)
        return try await table.delete(id: id)
    }
}
