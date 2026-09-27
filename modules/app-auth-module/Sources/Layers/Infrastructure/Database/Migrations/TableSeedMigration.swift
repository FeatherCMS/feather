//
//  TableSeedMigration.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

import AuthDomain
public import FeatherContracts
public import FeatherDatabase
public import FeatherDomain
public import FeatherInfrastructure
import UserApplication
import UserDomain
import UserInfrastructure

public struct TableSeedMigration: DatabaseMigration {

    public let connection: any DatabaseConnection
    private let idGenerator: any IDGenerator
    private let events: any EventPublisher

    public init(
        connection: any DatabaseConnection,
        idGenerator: any IDGenerator,
        events: any EventPublisher
    ) {
        self.connection = connection
        self.idGenerator = idGenerator
        self.events = events
    }

    public func apply(
        on connection: any DatabaseConnection
    ) async throws {
        let context = DatabaseTransactionContext(
            connection: connection,
            idGenerator: idGenerator
        )

        let rootPassword = try await BCryptPasswordHasher().hash("root")
        let identityRepository = IdentityDatabaseRepository(context: context)
        let authEmailRepository = AuthEmailDatabaseRepository(context: context)
        let credentialRepository = CredentialDatabaseRepository(
            context: context
        )

        let roleRepository = RoleDatabaseRepository(context: context)
        let rolePermissionRepository = RolePermissionDatabaseRepository(
            context: context
        )
        let roleDefinitions = try await events.trigger(
            event: UserRoleSeedProvider(),
            using: UserEventContext(idGenerator: idGenerator)
        ).flatMap { $0 }

        for definition in roleDefinitions {
            guard let role = try await roleRepository.findBy(key: definition.key)
            else {
                continue
            }

            let permissions = try await events.trigger(
                event: AccessControlProvider(roleKey: definition.key),
                using: AccessControlContext()
            ).flatMap { $0 }

            for permission in Set(permissions) {
                guard try await rolePermissionRepository.findBy(
                    roleId: role.id,
                    permissionId: permission.rawValue
                ) == nil
                else {
                    continue
                }

                _ = try await rolePermissionRepository.insert(
                    try RolePermission.create(
                        roleId: role.id,
                        permissionId: permission.rawValue
                    )
                )
            }
        }

        let identity: Identity
        if let existing = try await identityRepository.findRoot() {
            identity = existing
        }
        else {
            identity = try await identityRepository.insert(
                id: idGenerator.generate(),
                model: Identity.create(status: .active, isRoot: true)
            )
        }

        let rootEmail = "mail.tib@gmail.com"
        let authEmail: AuthEmail
        if let existing = try await authEmailRepository.findBy(email: rootEmail) {
            authEmail = existing
        }
        else {
            authEmail = try await authEmailRepository.insert(
                identityId: identity.id,
                email: rootEmail
            )
        }

        if try await credentialRepository.findBy(userId: identity.id) == nil {
            _ = try await credentialRepository.insert(
                Credential.create(
                    authEmailId: authEmail.id,
                    passwordHash: rootPassword
                )
            )
        }
    }
}
