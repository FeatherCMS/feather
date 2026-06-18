import FeatherDatabase
import Domain
import SystemDomain
import Infrastructure

extension VariableTable.Row {
    var asDomain: Variable {
        .init(
            id: id,
            name: name,
            value: value,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct DatabaseVariableRepository: VariableRepository {

    public var connection: any DatabaseConnection

    public init(connection: any DatabaseConnection) {
        self.connection = connection
    }

    public func insert(
        _ model: Variable.New
    ) async throws -> Variable {
        let table = VariableTable(connection: connection)
        let saved = try await table.create(
            row: .init(
                id: model.id,
                name: model.name,
                value: model.value,
                notes: model.notes
            )
        )
        return saved.asDomain
    }

    public func find(
        id: String
    ) async throws -> Variable? {
        let table = VariableTable(connection: connection)
        return try await table.find(id: id)?.asDomain
    }

    public func update(
        _ model: Variable
    ) async throws -> Variable {
        let table = VariableTable(connection: connection)
        let updated = try await table.update(
            id: model.id,
            row: .init(
                id: model.id,
                name: model.name,
                value: model.value,
                notes: model.notes,
                createdAt: model.createdAt,
                updatedAt: model.createdAt
            )
        )
        return updated.asDomain
    }

    public func delete(
        id: String
    ) async throws -> Bool {
        let table = VariableTable(connection: connection)
        return try await table.delete(id: id)
    }
}
