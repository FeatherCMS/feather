public import FeatherContracts
public import FeatherDatabase
public import FeatherInfrastructure
import UserApplication
import UserDomain

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
        let roleDefinitions =
            try await events.trigger(
                event: UserRoleSeedProvider(),
                using: UserEventContext(idGenerator: context.idGenerator)
            )
            .flatMap { $0 }

        let roleRepository = RoleDatabaseRepository(context: context)
        for definition in roleDefinitions
        where try await roleRepository.findBy(key: definition.key)
            == nil
        {
            _ = try await roleRepository.insert(
                try Role.create(
                    key: definition.key,
                    name: definition.name,
                    notes: definition.notes
                )
            )
        }

        let identityDefinitions =
            try await events.trigger(
                event: UserIdentitySeedProvider(),
                using: UserEventContext(idGenerator: context.idGenerator)
            )
            .flatMap { $0 }

        let identityRepository = IdentityDatabaseRepository(context: context)
        for definition in identityDefinitions {
            if definition.isRoot,
                try await identityRepository.findRoot() != nil
            {
                continue
            }
            if try await identityRepository.findBy(id: definition.id) != nil {
                continue
            }
            let identity = try await identityRepository.insert(
                id: definition.id,
                model: Identity.create(
                    name: definition.name,
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
