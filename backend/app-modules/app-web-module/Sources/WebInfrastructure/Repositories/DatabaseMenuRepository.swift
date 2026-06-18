import FeatherDatabase
import Domain
import WebDomain
import Infrastructure

extension MenuTable.Row {
    var asDomain: Menu {
        .init(
            id: id,
            key: key,
            name: name,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct DatabaseMenuRepository: MenuRepository {

    public var connection: any DatabaseConnection

    public init(connection: any DatabaseConnection) {
        self.connection = connection
    }

    public func insert(
        _ model: Menu.New
    ) async throws -> Menu {
        let table = MenuTable(connection: connection)
        let saved = try await table.create(
            row: .init(
                id: model.id,
                key: model.key,
                name: model.name,
                notes: model.notes
            )
        )
        return saved.asDomain
    }

    public func find(
        id: String
    ) async throws -> Menu? {
        let table = MenuTable(connection: connection)
        return try await table.find(id: id)?.asDomain
    }

    public func find(
        key: String
    ) async throws -> Menu? {
        let table = MenuTable(connection: connection)
        return try await table.find(key: key)?.asDomain
    }

    public func update(
        _ model: Menu
    ) async throws -> Menu {
        let table = MenuTable(connection: connection)
        let updated = try await table.update(
            id: model.id,
            row: .init(
                id: model.id,
                key: model.key,
                name: model.name,
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
        let table = MenuTable(connection: connection)
        return try await table.delete(id: id)
    }
}
