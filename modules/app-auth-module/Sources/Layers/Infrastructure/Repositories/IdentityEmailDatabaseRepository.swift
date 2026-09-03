import AuthDomain
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure

extension IdentityEmailTable.Row {
    var asDomain: IdentityEmail {
        .init(
            id: id,
            identityId: identityId,
            email: email,
            isPrimary: isPrimary,
            isVerified: isVerified,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct IdentityEmailDatabaseRepository: IdentityEmailRepository {
    public let context: DatabaseTransactionContext

    public init(context: DatabaseTransactionContext) {
        self.context = context
    }

    public func list() async throws -> [IdentityEmail] {
        try await IdentityEmailTable(connection: context.connection).list()
            .map(\.asDomain)
    }

    public func findBy(id: String) async throws -> IdentityEmail? {
        try await IdentityEmailTable(connection: context.connection)
            .find(id: id)?
            .asDomain
    }

    public func findBy(email: String) async throws -> IdentityEmail? {
        try await IdentityEmailTable(connection: context.connection)
            .findBy(email: email)?
            .asDomain
    }

    public func insert(identityId: String, email: String) async throws
        -> IdentityEmail
    {
        try await IdentityEmailTable(connection: context.connection)
            .save(
                id: context.idGenerator.generate(),
                identityId: identityId,
                email: email
            )
            .asDomain
    }

    public func update(_ model: IdentityEmail) async throws -> IdentityEmail {
        guard
            let row = try await IdentityEmailTable(
                connection: context.connection
            )
            .update(
                id: model.id,
                identityId: model.identityId,
                email: model.email,
                isPrimary: model.isPrimary,
                isVerified: model.isVerified
            )
        else { throw RepositoryError.notFound }
        return row.asDomain
    }

    public func delete(ids: [String]) async throws -> [String] {
        try await IdentityEmailTable(connection: context.connection)
            .delete(ids: ids)
    }
}
