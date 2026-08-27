//
//  TableSeedMigration.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

import AuthDomain
import BCrypt
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import NIOPosix
import UserDomain
import UserInfrastructure

public struct TableSeedMigration: DatabaseMigration {

    public let connection: any DatabaseConnection
    private let idGenerator: any IDGenerator

    public init(
        connection: any DatabaseConnection,
        idGenerator: any IDGenerator
    ) {
        self.connection = connection
        self.idGenerator = idGenerator
    }

    public func apply(
        on connection: any DatabaseConnection
    ) async throws {
        let context = DatabaseTransactionContext(
            connection: connection,
            idGenerator: idGenerator
        )

        let rootPassword = try await NIOThreadPool.singleton.runIfActive {
            try BCrypt().hash("root")
        }
        let identityRepository = IdentityDatabaseRepository(context: context)
        let credentialRepository = CredentialDatabaseRepository(
            context: context
        )

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

        guard
            try await credentialRepository.findBy(userId: identity.id)
                == nil
        else {
            return
        }

        _ = try await credentialRepository.insert(
            Credential.create(
                userId: identity.id,
                email: "mail.tib@gmail.com",
                passwordHash: rootPassword
            )
        )
    }
}
