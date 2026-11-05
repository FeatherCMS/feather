import AuthDomain
import AuthModule
import FeatherDBAL
public import FeatherDatabase
import FeatherDomain
public import FeatherInfrastructure
public import FeatherModuleKit
import UserApplication
import UserDomain
import UserInfrastructure
import UserModule

//
//  Table+SeedMigration.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

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
        let rootPassword = try await BCryptPasswordHasher().hash("root")
        let identityRepository = Identity.Repository.Database(context: context)
        let authEmailRepository = Email.Repository.Database(
            context: context
        )
        let credentialRepository = Credential.Repository.Database(
            context: context
        )

        let roleRepository = Role.Repository.Database(context: context)
        let rolePermissionRepository = RolePermission.Repository.Database(
            context: context
        )
        let roleDefinitions =
            try await events.trigger(
                event: Role.Event.Seed.Provider(),
                using: UserModule.Event.Context(
                    idGenerator: context.idGenerator
                )
            )
            .flatMap { $0 }

        for definition in roleDefinitions {
            guard
                let role = try await roleRepository.findBy(key: definition.key)
            else {
                continue
            }

            let permissions =
                try await events.trigger(
                    event: AccessControlProvider(roleKey: definition.key),
                    using: AccessControlContext()
                )
                .flatMap { $0 }

            for permission in Set(permissions)
            where try await rolePermissionRepository.findBy(
                roleId: role.id,
                permissionId: permission.rawValue
            ) == nil {
                _ = try await rolePermissionRepository.insert(
                    try RolePermission.Model.create(
                        roleId: role.id,
                        permissionId: permission.rawValue
                    )
                )
            }
        }

        let identity: Identity.Model
        if let existing = try await identityRepository.findRoot() {
            identity = existing
        }
        else {
            identity = try await identityRepository.insert(
                id: context.idGenerator.generate(),
                model: Identity.Model.create(status: .active, isRoot: true)
            )
        }

        let rootEmail = "mail.tib@gmail.com"
        let authEmail: Email.Model
        if let existing = try await authEmailRepository.findBy(email: rootEmail)
        {
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
                Credential.Model.create(
                    authEmailId: authEmail.id,
                    passwordHash: rootPassword
                )
            )
        }
    }
}
