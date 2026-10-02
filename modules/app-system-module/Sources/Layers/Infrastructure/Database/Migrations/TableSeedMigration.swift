public import FeatherContracts
public import FeatherDatabase
public import FeatherInfrastructure
import SystemApplication
import SystemDomain

public struct TableSeedMigration: DatabaseMigration {
    public let context: DatabaseTransactionContext
    private let events: any EventPublisher

    public var connection: any DatabaseConnection {
        context.connection
    }

    public init(
        context: DatabaseTransactionContext,
        events: any EventPublisher
    ) {
        self.context = context
        self.events = events
    }

    public func apply(
        on connection: any DatabaseConnection
    ) async throws {
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
                    key: permission.key,
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
                    key: variable.key,
                    value: variable.value,
                    name: variable.name,
                    notes: variable.notes
                )
            )
        }
    }
}
