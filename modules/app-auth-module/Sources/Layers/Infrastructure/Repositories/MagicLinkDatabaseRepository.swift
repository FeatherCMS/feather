//
//  MagicLinkDatabaseRepository.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

import AuthDomain
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure

import struct Foundation.Date

extension MagicLinkTable.Row {
    var asDomain: MagicLink {
        .init(
            id: id,
            authEmailId: authEmailId,
            token: token,
            expiresAt: expiresAt,
            isPersistent: isPersistent,
            isUsed: isUsed,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct MagicLinkDatabaseRepository: MagicLinkRepository {

    public let context: DatabaseTransactionContext
    public init(context: DatabaseTransactionContext) {
        self.context = context
    }

    public func findById(
        id: String
    ) async throws -> MagicLink? {
        let table = MagicLinkTable(connection: context.connection)
        return try await table.find(id: id)?.asDomain
    }

    public func insert(
        _ model: MagicLink.New
    ) async throws -> MagicLink {
        let table = MagicLinkTable(connection: context.connection)
        let saved = try await table.save(
            row: .init(
                id: context.idGenerator.generate(),
                authEmailId: model.authEmailId,
                token: model.token,
                expiresAtInterval: model.expiresAtInterval,
                isPersistent: model.isPersistent,
                isUsed: false
            )
        )
        return saved.asDomain
    }

    public func update(
        _ model: MagicLink
    ) async throws -> MagicLink {
        let table = MagicLinkTable(connection: context.connection)
        let updated = try await table.update(
            id: model.id,
            row: .init(
                id: model.id,
                authEmailId: model.authEmailId,
                token: model.token,
                expiresAt: model.expiresAt,
                isPersistent: model.isPersistent,
                isUsed: model.isUsed,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt
            )
        )
        guard let updated else {
            throw RepositoryError.notFound
        }
        return updated.asDomain
    }

    public func consumeByToken(
        token: String
    ) async throws -> MagicLink {
        let table = MagicLinkTable(connection: context.connection)
        guard let consumed = try await table.consume(token: token)
        else {
            guard let existing = try await table.find(token: token) else {
                throw MagicLink.Error.invalidToken
            }
            if existing.isUsed {
                throw MagicLink.Error.alreadyUsed
            }
            if existing.expiresAt <= Date() {
                throw MagicLink.Error.expired
            }
            throw MagicLink.Error.invalidToken
        }
        return consumed.asDomain
    }

    public func delete(
        ids: [String]
    ) async throws -> [String] {
        let table = MagicLinkTable(connection: context.connection)
        return try await table.delete(ids: ids)
    }
}
