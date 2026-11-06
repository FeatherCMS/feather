public import FeatherDBAL
public import FeatherDatabase
public import FeatherInfrastructure
public import FeatherModuleKit
import SystemApplication
import SystemDomain
import SystemModule

public struct TableSeedMigration: DatabaseMigration {
    public let context: DatabaseTransactionContext
    public let platform: any DatabasePlatform
    private let events: any EventPublisher

    public var connection: any DatabaseConnection {
        context.connection
    }

    public init(
        context: DatabaseTransactionContext,
        platform: any DatabasePlatform,
        events: any EventPublisher
    ) {
        self.context = context
        self.platform = platform
        self.events = events
    }

    public func apply(
        on connection: any DatabaseConnection
    ) async throws {
        // insert permissions via the event hook

        let permissions =
            try await events.trigger(
                event: SystemModule.Permission.Event.Seed()
            )
            .flatMap { $0 }

        let permissionRepository = SystemModule.Permission.Repository.Database(
            context: context
        )
        for permission in permissions {
            _ = try await permissionRepository.insert(
                try SystemModule.Permission.Model.create(
                    key: permission.key,
                    name: permission.name,
                    notes: permission.notes
                )
            )
        }

        // insert variables via the event hook

        let variables =
            try await events.trigger(
                event: SystemModule.Variable.Event.Seed()
            )
            .flatMap { $0 }

        let variableRepository = SystemModule.Variable.Repository.Database(
            context: context
        )
        let uniqueVariableDefinitions = variables.reduce(
            into: [String: SystemModule.Variable.Seed]()
        ) { definitions, variable in
            definitions[variable.key] = variable
        }
        for variable in uniqueVariableDefinitions.values {
            _ = try await variableRepository.insert(
                try SystemModule.Variable.Model.create(
                    key: variable.key,
                    value: variable.value,
                    name: variable.name,
                    notes: variable.notes
                )
            )
        }
    }
}
