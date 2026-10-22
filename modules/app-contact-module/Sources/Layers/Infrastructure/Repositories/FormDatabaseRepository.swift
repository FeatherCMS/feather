public import ContactDomain
public import ContactModule
import FeatherDBAL
import FeatherDomain
public import FeatherInfrastructure

extension FormTable.Row {
    var asDomain: Form.Model {
        .init(
            id: id,
            key: key,
            name: name,
            successMessage: successMessage,
            failureMessage: failureMessage,
            redirectUrl: redirectUrl,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct FormDatabaseRepository: Form.Repository.Interface {

    public let context: DatabaseTransactionContext
    public init(context: DatabaseTransactionContext) {
        self.context = context
    }

    public func list() async throws -> [Form.Model] {
        try await FormTable(connection: context.connection).list()
            .map(\.asDomain)
    }

    public func insert(
        _ model: Form.Model.New
    ) async throws -> Form.Model {
        let table = FormTable(connection: context.connection)
        let saved = try await table.create(
            row: .init(
                id: context.idGenerator.generate(),
                key: model.key,
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
    ) async throws -> Form.Model? {
        let table = FormTable(connection: context.connection)
        return try await table.find(id: id)?.asDomain
    }

    public func findBy(
        key: String
    ) async throws -> Form.Model? {
        let table = FormTable(connection: context.connection)
        return try await table.find(key: key)?.asDomain
    }

    public func update(
        _ model: Form.Model
    ) async throws -> Form.Model {
        let table = FormTable(connection: context.connection)
        let updated = try await table.update(
            id: model.id,
            row: .init(
                id: model.id,
                key: model.key,
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
        ids: [String]
    ) async throws -> [String] {
        try await DatabaseAccessLayer<FormTable>(context: context).delete(where: \.id, in: ids)
        return ids
    }
}
