import AccountApplication
import AccountDomain
import FeatherDatabase
import FeatherInfrastructure

public struct AccountProfileDatabaseQueries: AccountProfileQueries {
    public let context: DatabaseQueryContext

    public init(
        context: DatabaseQueryContext
    ) {
        self.context = context
    }

    public func get(
        userId: String
    ) async throws -> AccountProfile {
        try await AccountProfileTable(connection: context.connection)
            .get(userId: userId)
            .asQueryDomain
    }
}

extension AccountProfileTable.Row {
    fileprivate var asQueryDomain: AccountProfile {
        get throws {
            .init(
                userId: userId,
                firstName: firstName,
                lastName: lastName,
                imageURL: imageURL,
                createdAt: createdAt,
                updatedAt: updatedAt
            )
        }
    }
}
