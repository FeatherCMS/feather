//
//  AuthorLinkDatabaseRepository.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

import BlogDomain
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure

extension AuthorLinkTable.Row {
    var asDomain: AuthorLink {
        .init(
            id: id,
            authorId: authorId,
            label: label,
            url: url,
            priority: priority,
            isBlank: isBlank,
            permission: permission,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct AuthorLinkDatabaseRepository: AuthorLinkRepository {

    public let context: DatabaseTransactionContext
    public init(context: DatabaseTransactionContext) {
        self.context = context
    }

    public func insert(
        _ model: AuthorLink.New
    ) async throws -> AuthorLink {
        let table = AuthorLinkTable(connection: context.connection)
        let saved = try await table.create(
            row: .init(
                id: context.idGenerator.generate(),
                authorId: model.authorId,
                label: model.label,
                url: model.url,
                priority: model.priority,
                isBlank: model.isBlank,
                permission: model.permission,
                notes: model.notes
            )
        )
        return saved.asDomain
    }

    public func find(
        id: String
    ) async throws -> AuthorLink? {
        let table = AuthorLinkTable(connection: context.connection)
        return try await table.find(id: id)?.asDomain
    }

    public func update(
        _ model: AuthorLink
    ) async throws -> AuthorLink {
        let table = AuthorLinkTable(connection: context.connection)
        let updated = try await table.update(
            id: model.id,
            row: .init(
                id: model.id,
                authorId: model.authorId,
                label: model.label,
                url: model.url,
                priority: model.priority,
                isBlank: model.isBlank,
                permission: model.permission,
                notes: model.notes,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt
            )
        )
        return updated.asDomain
    }

    public func delete(
        id: String
    ) async throws -> Bool {
        let table = AuthorLinkTable(connection: context.connection)
        return try await table.delete(id: id)
    }
}
