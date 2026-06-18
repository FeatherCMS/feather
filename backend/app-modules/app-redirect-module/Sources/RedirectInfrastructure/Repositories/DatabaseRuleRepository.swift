import FeatherDatabase
import Domain
import RedirectDomain
import Infrastructure

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

public struct DatabaseRuleRepository: RuleRepository {

    public var connection: any DatabaseConnection

    public init(connection: any DatabaseConnection) {
        self.connection = connection
    }

    public func insert(
        _ model: Rule.New
    ) async throws -> Rule {
        let table = RuleTable(connection: connection)
        let saved = try await table.create(
            row: .init(
                id: model.id,
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
        let table = RuleTable(connection: connection)
        return try await table.find(id: id)?.asDomain
    }

    public func find(
        source: String
    ) async throws -> Rule? {
        let table = RuleTable(connection: connection)
        return try await table.find(source: source)?.asDomain
    }

    public func update(
        _ model: Rule
    ) async throws -> Rule {
        let table = RuleTable(connection: connection)
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
        id: String
    ) async throws -> Bool {
        let table = RuleTable(connection: connection)
        return try await table.delete(id: id)
    }
}
