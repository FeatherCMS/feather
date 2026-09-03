import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import SystemApplication
import SystemDomain

/// Installs permissions added after the initial system seed migration.
public struct PermissionSeedMigration: DatabaseMigration {
    public let connection: any DatabaseConnection
    private let events: any EventPublisher
    private let idGenerator: any IDGenerator

    public init(
        connection: any DatabaseConnection,
        events: any EventPublisher,
        idGenerator: any IDGenerator
    ) {
        self.connection = connection
        self.events = events
        self.idGenerator = idGenerator
    }

    public func apply(
        on connection: any DatabaseConnection
    ) async throws {
        let context = DatabaseTransactionContext(
            connection: connection,
            idGenerator: idGenerator
        )
        let repository = PermissionDatabaseRepository(context: context)
        let permissions =
            try await events
            .trigger(event: PermissionSeedProvider(), using: EventContext())
            .flatMap { $0 }

        for permission in permissions
        where try await repository.find(id: permission.id) == nil {
            _ = try await repository.insert(
                try Permission.create(
                    id: permission.id,
                    name: permission.name,
                    notes: permission.notes
                )
            )
        }
    }
}
