//
//  RuleDatabaseRepository.swift
//  app-redirect-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import RedirectDomain

extension RuleTable.Row {
    var asDomain: Rule {
        .init(
            id: id,
            source: source,
            destination: destination,
            statusCode: statusCode,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct RuleDatabaseRepository: RuleRepository {

    public let context: DatabaseTransactionContext
    public init(context: DatabaseTransactionContext) {
        self.context = context
    }

    public func insert(
        _ model: Rule.New
    ) async throws -> Rule {
        let table = RuleTable(connection: context.connection)
        let saved = try await table.create(
            row: .init(
                id: context.idGenerator.generate(),
                source: model.source,
                destination: model.destination,
                statusCode: model.statusCode,
                notes: model.notes
            )
        )
        return saved.asDomain
    }

    public func find(
        id: String
    ) async throws -> Rule? {
        let table = RuleTable(connection: context.connection)
        return try await table.find(id: id).map(\.asDomain)
    }

    public func find(
        source: String
    ) async throws -> Rule? {
        let table = RuleTable(connection: context.connection)
        return try await table.find(source: source).map(\.asDomain)
    }

    public func update(
        _ model: Rule
    ) async throws -> Rule {
        let table = RuleTable(connection: context.connection)
        let updated = try await table.update(
            id: model.id,
            row: .init(
                id: model.id,
                source: model.source,
                destination: model.destination,
                statusCode: model.statusCode,
                notes: model.notes,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt
            )
        )
        return updated.asDomain
    }

    public func delete(
        ids: [String]
    ) async throws -> [String] {
        let table = RuleTable(connection: context.connection)
        return try await table.delete(ids: ids)
    }
}
