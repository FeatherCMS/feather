//
//  InvitationDatabaseRepository.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import AccountDomain
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure

import struct Foundation.Date

extension InvitationTable.Row {
    var asDomain: Invitation {
        .init(
            id: id,
            userId: userId,
            email: email,
            token: token,
            roleIDs: roleIDs,
            expiresAt: expiresAt,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct InvitationDatabaseRepository: InvitationRepository {

    public let context: DatabaseTransactionContext
    public init(context: DatabaseTransactionContext) {
        self.context = context
    }

    public func findBy(
        id: String
    ) async throws -> Invitation? {
        let table = InvitationTable(connection: context.connection)
        return try await table.find(id: id)?.asDomain
    }

    public func findBy(
        token: String
    ) async throws -> Invitation? {
        let table = InvitationTable(connection: context.connection)
        return try await table.find(token: token)?.asDomain
    }

    public func insert(
        _ model: Invitation.New
    ) async throws -> Invitation {
        let table = InvitationTable(connection: context.connection)
        let saved = try await table.save(
            row: .init(
                id: context.idGenerator.generate(),
                userId: model.userId,
                email: model.email,
                token: model.token,
                roleIDs: model.roleIDs,
                expiresAtInterval: model.expiresAtInterval
            )
        )
        return saved.asDomain
    }

    public func update(
        _ model: Invitation
    ) async throws -> Invitation {
        let table = InvitationTable(connection: context.connection)
        let updated = try await table.update(
            id: model.id,
            row: .init(
                id: model.id,
                userId: model.userId,
                email: model.email,
                token: model.token,
                roleIDs: model.roleIDs,
                expiresAt: model.expiresAt,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt
            )
        )
        guard let updated else {
            throw RepositoryError.notFound
        }
        return updated.asDomain
    }

    public func delete(
        ids: [String]
    ) async throws -> [String] {
        let table = InvitationTable(connection: context.connection)
        return try await table.delete(ids: ids)
    }
}
