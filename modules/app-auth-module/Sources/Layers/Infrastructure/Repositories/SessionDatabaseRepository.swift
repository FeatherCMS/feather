//
//  SessionDatabaseRepository.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

import AuthDomain
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure

import struct Foundation.Date

extension SessionTable.Row {
    var asDomain: Session {
        .init(
            id: id,
            token: token,
            identityId: identityId,
            authenticationType: authenticationType,
            authenticationReference: authenticationReference,
            expiresAt: expiresAt.timeIntervalSince1970,
            isPersistent: isPersistent,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct SessionDatabaseRepository: SessionRepository {

    public let context: DatabaseTransactionContext
    public init(context: DatabaseTransactionContext) {
        self.context = context
    }

    public func findBy(
        id: String
    ) async throws -> Session? {
        let table = SessionTable(connection: context.connection)
        return try await table.find(id: id)?.asDomain
    }

    public func findBy(
        token: String
    ) async throws -> Session? {
        let table = SessionTable(connection: context.connection)
        return try await table.find(token: token)?.asDomain
    }

    public func insert(
        _ model: Session.New
    ) async throws -> Session {
        let table = SessionTable(connection: context.connection)
        let saved = try await table.save(
            row: .init(
                id: context.idGenerator.generate(),
                token: model.token,
                identityId: model.identityId,
                authenticationType: model.authenticationType,
                authenticationReference: model.authenticationReference,
                isPersistent: model.isPersistent,
                expiresAtInterval: model.expiresAtInterval
            )
        )
        return saved.asDomain
    }

    public func update(
        _ model: Session
    ) async throws -> Session {
        let table = SessionTable(connection: context.connection)
        let updated = try await table.update(
            id: model.id,
            row: .init(
                id: model.id,
                token: model.token,
                identityId: model.identityId,
                authenticationType: model.authenticationType,
                authenticationReference: model.authenticationReference,
                isPersistent: model.isPersistent,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt,
                expiresAt: .init(timeIntervalSince1970: model.expiresAt)
            )
        )
        guard let updated else {
            throw RepositoryError.notFound
        }
        return updated.asDomain
    }

    public func delete(
        id: String
    ) async throws -> Bool {
        let table = SessionTable(connection: context.connection)
        return try await table.delete(id: id)
    }
}
