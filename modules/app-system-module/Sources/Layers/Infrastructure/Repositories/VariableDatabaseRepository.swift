//
//  VariableDatabaseRepository.swift
//  app-system-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherDomain
public import FeatherInfrastructure
public import SystemDomain

extension VariableTable.Row.Detail {
    var asDomain: Variable {
        .init(
            id: id,
            key: key,
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
    public let idGenerator: any IDGenerator

    public init(context: any DatabaseContext) {
        self.context = context
        self.idGenerator = NanoIDGenerator()
    }

    public init(context: DatabaseTransactionContext) {
        self.context = context
        self.idGenerator = context.idGenerator
    }

    public func insert(
        _ model: Variable.New
    ) async throws -> Variable {
        let table = VariableTable(connection: context.connection)
        guard let saved = try await table.insert(
            VariableTable.Row.Create(
                id: idGenerator.generate(),
                key: model.key,
                value: model.value,
                name: model.name,
                notes: model.notes
            ),
            returning: VariableTable.Row.Detail.self
        ) else {
            throw RepositoryError.notFound
        }
        return saved.asDomain
    }

    public func find(
        key: String
    ) async throws -> Variable? {
        let table = VariableTable(connection: context.connection)
        return try await table.findFirst(
            by: VariableTable.Fields.key,
            equals: key,
            returning: VariableTable.Row.Detail.self
        )?.asDomain
    }

    public func find(
        id: String
    ) async throws -> Variable? {
        let table = VariableTable(connection: context.connection)
        return try await table.findFirst(
            by: VariableTable.Fields.id,
            equals: id,
            returning: VariableTable.Row.Detail.self
        )?.asDomain
    }

    public func update(
        _ model: Variable
    ) async throws -> Variable {
        let table = VariableTable(connection: context.connection)
        guard let updated = try await table.update(
            VariableTable.Row.Update(
                key: model.key,
                value: model.value,
                name: model.name,
                notes: model.notes
            ),
            matching: model.id,
            returning: VariableTable.Row.Detail.self
        ) else {
            throw RepositoryError.notFound
        }
        return updated.asDomain
    }

    public func delete(
        ids: [String]
    ) async throws -> [String] {
        let table = VariableTable(connection: context.connection)
        return try await table.delete(ids: ids)
    }
}
