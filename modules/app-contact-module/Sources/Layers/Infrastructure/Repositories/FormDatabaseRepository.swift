import ContactDomain
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure

extension FormTable.Row {
    var asDomain: Form {
        .init(
            id: id,
            name: name,
            successMessage: successMessage,
            failureMessage: failureMessage,
            redirectUrl: redirectUrl,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct FormDatabaseRepository: FormRepository {

    public let context: DatabaseTransactionContext
    public init(context: DatabaseTransactionContext) {
        self.context = context
    }

    public func list() async throws -> [Form] {
        try await FormTable(connection: context.connection).list()
            .map(\.asDomain)
    }

    public func insert(
        _ model: Form.New
    ) async throws -> Form {
        let table = FormTable(connection: context.connection)
        let saved = try await table.create(
            row: .init(
                id: context.idGenerator.generate(),
                name: model.name,
                successMessage: model.successMessage,
                failureMessage: model.failureMessage,
                redirectUrl: model.redirectUrl
            )
        )
        return saved.asDomain
    }

    public func findBy(
        id: String
    ) async throws -> Form? {
        let table = FormTable(connection: context.connection)
        return try await table.find(id: id)?.asDomain
    }

    public func update(
        _ model: Form
    ) async throws -> Form {
        let table = FormTable(connection: context.connection)
        let updated = try await table.update(
            id: model.id,
            row: .init(
                id: model.id,
                name: model.name,
                successMessage: model.successMessage,
                failureMessage: model.failureMessage,
                redirectUrl: model.redirectUrl,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt
            )
        )
        return updated.asDomain
    }

    public func delete(
        id: String
    ) async throws -> Bool {
        let table = FormTable(connection: context.connection)
        return try await table.delete(id: id)
    }
}
