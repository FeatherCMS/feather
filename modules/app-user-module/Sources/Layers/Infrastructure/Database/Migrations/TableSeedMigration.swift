import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import SystemApplication
import UserApplication
import UserDomain

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
        let roleDefinitions =
            try await events.trigger(
                event: UserRoleSeedProvider(),
                using: UserEventContext()
            )
            .flatMap { $0 }

        let roleRepository = RoleDatabaseRepository(context: context)
        for definition in roleDefinitions
        where try await roleRepository.findBy(id: definition.id) == nil {
            _ = try await roleRepository.insert(
                try Role.create(
                    id: definition.id,
                    name: definition.name,
                    notes: definition.notes
                )
            )
        }

        let identityDefinitions =
            try await events.trigger(
                event: UserIdentitySeedProvider(),
                using: UserEventContext()
            )
            .flatMap { $0 }

        let identityRepository = IdentityDatabaseRepository(context: context)
        for definition in identityDefinitions {
            let identity = try await identityRepository.insert(
                id: definition.id,
                model: Identity.create(
                    status: .init(rawValue: definition.status.rawValue)
                        ?? .active,
                    isRoot: definition.isRoot
                )
            )
            try await identityRepository.replaceRoleIds(
                identityId: identity.id,
                roleIds: definition.roleIDs
            )
            try await events.trigger(
                event: UserIdentityDidInsert(identityID: identity.id),
                using: context
            )
        }
    }
}
