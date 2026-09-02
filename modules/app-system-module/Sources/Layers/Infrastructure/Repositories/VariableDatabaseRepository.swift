//
//  VariableDatabaseRepository.swift
//  app-system-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import SystemDomain

extension VariableTable.Row {
    var asDomain: Variable {
        .init(
            id: id,
            value: value,
            name: name,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct VariableDatabaseRepository: VariableRepository {

    public let context: any DatabaseContext

    public init(context: any DatabaseContext) {
        self.context = context
    }

    public func insert(
        _ model: Variable.New
    ) async throws -> Variable {
        let table = VariableTable(connection: context.connection)
        let saved = try await table.create(
            row: .init(
                id: model.id,
                value: model.value,
                name: model.name,
                notes: model.notes
            )
        )
        return saved.asDomain
    }

    public func find(
        id: String
    ) async throws -> Variable? {
        let table = VariableTable(connection: context.connection)
        return try await table.find(id: id)?.asDomain
    }

    public func update(
        _ model: Variable
    ) async throws -> Variable {
        let table = VariableTable(connection: context.connection)
        let updated = try await table.update(
            id: model.id,
            row: .init(
                id: model.id,
                value: model.value,
                name: model.name,
                notes: model.notes,
                createdAt: model.createdAt,
                updatedAt: model.createdAt
            )
        )
        return updated.asDomain
    }

    public func delete(
        ids: [String]
    ) async throws -> Bool {
        let table = VariableTable(connection: context.connection)
        var removed = true
        for id in ids {
            removed = try await table.delete(id: id) && removed
        }
        return removed
    }
}
