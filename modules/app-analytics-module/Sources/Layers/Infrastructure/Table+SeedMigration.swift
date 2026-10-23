public import FeatherDatabase
public import FeatherInfrastructure

public struct TableSeedMigration: DatabaseMigration {
    public let context: DatabaseTransactionContext

    public var connection: any DatabaseConnection {
        context.connection
    }

    public init(context: DatabaseTransactionContext) {
        self.context = context
    }

    public func apply(on connection: any DatabaseConnection) async throws {
        try await AnalyticsPermissionSeed(connection: context.connection).apply()
    }
}
