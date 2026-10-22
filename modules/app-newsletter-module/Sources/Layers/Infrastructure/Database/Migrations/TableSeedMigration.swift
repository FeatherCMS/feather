import FeatherDBAL
public import FeatherDatabase
public import FeatherInfrastructure
import NewsletterDomain
import NewsletterModule

public struct TableSeedMigration: DatabaseMigration {
    public let context: DatabaseTransactionContext

    public var connection: any DatabaseConnection {
        context.connection
    }

    public init(
        context: DatabaseTransactionContext
    ) {
        self.context = context
    }

    public func apply(
        on connection: any DatabaseConnection
    ) async throws {
        let repository = CampaignDatabaseRepository(context: context)
        guard try await repository.findBy(key: "website") == nil else {
            return
        }
        _ = try await repository.insert(
            try Campaign.Model.create(
                key: "website",
                name: "Website"
            )
        )
    }
}
