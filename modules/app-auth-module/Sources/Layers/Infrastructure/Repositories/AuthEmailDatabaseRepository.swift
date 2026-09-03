import AuthDomain
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure

extension AuthEmailTable.Row {
    var asDomain: AuthEmail {
        .init(
            id: id,
            identityId: identityId,
            email: email,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct AuthEmailDatabaseRepository: AuthEmailRepository {
    public let context: DatabaseTransactionContext

    public init(context: DatabaseTransactionContext) {
        self.context = context
    }

    public func list() async throws -> [AuthEmail] {
        try await AuthEmailTable(connection: context.connection).list()
            .map(\.asDomain)
    }

    public func findBy(id: String) async throws -> AuthEmail? {
        try await AuthEmailTable(connection: context.connection)
            .find(id: id)?
            .asDomain
    }

    public func findBy(email: String) async throws -> AuthEmail? {
        try await AuthEmailTable(connection: context.connection)
            .findBy(email: email)?
            .asDomain
    }

    public func insert(identityId: String, email: String) async throws
        -> AuthEmail
    {
        try await AuthEmailTable(connection: context.connection)
            .save(
                id: context.idGenerator.generate(),
                identityId: identityId,
                email: email
            )
            .asDomain
    }

    public func update(_ model: AuthEmail) async throws -> AuthEmail {
        guard
            let row = try await AuthEmailTable(
                connection: context.connection
            )
            .update(
                id: model.id,
                identityId: model.identityId,
                email: model.email
            )
        else { throw RepositoryError.notFound }
        return row.asDomain
    }

    public func delete(ids: [String]) async throws -> [String] {
        try await AuthEmailTable(connection: context.connection)
            .delete(ids: ids)
    }
}
