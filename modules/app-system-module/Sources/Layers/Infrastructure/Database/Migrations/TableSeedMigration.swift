import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import SystemApplication
import SystemDomain

public struct TableSeedMigration: DatabaseMigration {
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

        // insert permissions via the event hook

        let permissions =
            try await events.trigger(
                event: PermissionSeedProvider(),
                using: EventContext()
            )
            .flatMap { $0 }

        let permissionRepository = PermissionDatabaseRepository(
            context: context
        )
        for permission in permissions {
            _ = try await permissionRepository.insert(
                try Permission.create(
                    id: permission.id,
                    name: permission.name,
                    notes: permission.notes
                )
            )
        }

        // insert variables via the event hook

        let variables =
            try await events.trigger(
                event: VariableSeedProvider(),
                using: EventContext()
            )
            .flatMap { $0 }

        let variableRepository = VariableDatabaseRepository(context: context)
        for variable in variables {
            _ = try await variableRepository.insert(
                try Variable.create(
                    id: variable.id,
                    value: variable.value,
                    name: variable.name,
                    notes: variable.notes
                )
            )
        }
    }
}
