import AccountApplication
import AuthDomain
import AuthInfrastructure
public import FeatherContracts
public import FeatherDatabase
public import FeatherDomain
public import FeatherInfrastructure
import UserApplication
import UserDomain
import UserInfrastructure
import SystemApplication

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
        let definitions = try await events.trigger(
            event: AccountSeedProvider(),
            using: EventContext()
        ).flatMap { $0 }

        let identityRepository = IdentityDatabaseRepository(context: context)
        let authEmailRepository = AuthEmailDatabaseRepository(context: context)
        let credentialRepository = CredentialDatabaseRepository(context: context)
        let roleRepository = RoleDatabaseRepository(context: context)
        let passwordHasher = BCryptPasswordHasher()

        for definition in definitions {
            let identityID: String
            let isNewIdentity: Bool
            if let authEmail = try await authEmailRepository.findBy(
                email: definition.email
            ) {
                identityID = authEmail.identityId
                isNewIdentity = false
            }
            else {
                let identity = try await identityRepository.insert(
                    Identity.create(
                        name: definition.email,
                        status: .active
                    )
                )
                _ = try await authEmailRepository.insert(
                    identityId: identity.id,
                    email: definition.email
                )
                identityID = identity.id
                isNewIdentity = true
            }

            if try await credentialRepository.findBy(
                email: definition.email
            ) == nil {
                guard let authEmail = try await authEmailRepository.findBy(
                    email: definition.email
                ) else {
                    throw RepositoryError.notFound
                }
                let passwordHash = try await passwordHasher.hash(
                    definition.password
                )
                _ = try await credentialRepository.insert(
                    Credential.create(
                        authEmailId: authEmail.id,
                        passwordHash: passwordHash
                    )
                )
            }

            if isNewIdentity {
                try await events.trigger(
                    event: UserIdentityDidInsert(identityID: identityID),
                    using: context
                )
            }

            var roleIDs: [String] = []
            for key in definition.roleKeys {
                guard let role = try await roleRepository.findBy(key: key)
                else {
                    throw RepositoryError.notFound
                }
                roleIDs.append(role.id)
            }
            try await identityRepository.replaceRoleIds(
                identityId: identityID,
                roleIds: roleIDs
            )
        }
    }
}
