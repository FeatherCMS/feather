import ContactDomain
import Domain
import FeatherDatabase
import Infrastructure

extension ContactFormTable.Row {
    var asDomain: ContactForm {
        .init(
            id: id,
            name: name,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct DatabaseContactFormRepository: ContactFormRepository {

    public var connection: any DatabaseConnection

    public init(connection: any DatabaseConnection) {
        self.connection = connection
    }

    public func list() async throws -> [ContactForm] {
        try await ContactFormTable(connection: connection).list().map(\.asDomain)
    }

    public func insert(
        _ model: ContactForm.New
    ) async throws -> ContactForm {
        let table = ContactFormTable(connection: connection)
        let saved = try await table.create(
            row: .init(
                id: model.id,
                name: model.name
            )
        )
        return saved.asDomain
    }

    public func findBy(
        id: String
    ) async throws -> ContactForm? {
        let table = ContactFormTable(connection: connection)
        return try await table.find(id: id)?.asDomain
    }

    public func update(
        _ model: ContactForm
    ) async throws -> ContactForm {
        let table = ContactFormTable(connection: connection)
        let updated = try await table.update(
            id: model.id,
            row: .init(
                id: model.id,
                name: model.name,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt
            )
        )
        return updated.asDomain
    }

    public func delete(
        id: String
    ) async throws -> Bool {
        let table = ContactFormTable(connection: connection)
        return try await table.delete(id: id)
    }
}
