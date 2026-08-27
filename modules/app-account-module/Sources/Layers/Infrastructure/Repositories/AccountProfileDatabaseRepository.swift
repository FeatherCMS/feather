import AccountApplication
import AccountDomain
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure

public struct AccountProfileDatabaseRepository: AccountProfileRepository {
    public let context: DatabaseTransactionContext

    public init(context: DatabaseTransactionContext) {
        self.context = context
    }

    public func get(userId: String) async throws -> AccountProfile {
        try await AccountProfileTable(connection: context.connection)
            .get(userId: userId).asDomain
    }

    public func getOrCreate(userId: String) async throws -> AccountProfile {
        do { return try await get(userId: userId) }
        catch let error as RepositoryError where error.reason == .database(.notFound) {
            try await create(userId: userId)
            return try await get(userId: userId)
        }
        catch let error as DatabaseError {
            guard case .query(let underlying) = error,
                let repositoryError = underlying as? RepositoryError,
                repositoryError.reason == .database(.notFound)
            else { throw error }
            try await create(userId: userId)
            return try await get(userId: userId)
        }
    }

    public func create(userId: String) async throws {
        let new = try AccountProfile.create(userId: userId)
        _ = try await AccountProfileTable(connection: context.connection).create(
            row: .init(
                id: context.idGenerator.generate(), userId: new.userId,
                firstName: new.firstName, lastName: new.lastName, imageURL: new.imageURL
            )
        )
    }

    public func update(_ model: AccountProfile) async throws -> AccountProfile {
        try await AccountProfileTable(connection: context.connection).update(
            userId: model.userId,
            row: .init(firstName: model.firstName, lastName: model.lastName, imageURL: model.imageURL)
        ).asDomain
    }

    public func delete(userId: String) async throws {
        try await AccountProfileTable(connection: context.connection).delete(userId: userId)
    }
}

extension AccountProfileTable.Row {
    fileprivate var asDomain: AccountProfile {
        get throws {
            .init(userId: userId, firstName: firstName, lastName: lastName,
                  imageURL: imageURL, createdAt: createdAt, updatedAt: updatedAt)
        }
    }
}
