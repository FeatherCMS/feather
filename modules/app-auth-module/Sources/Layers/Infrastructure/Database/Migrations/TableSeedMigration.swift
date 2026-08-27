//
//  TableSeedMigration.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

import AuthDomain
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
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

        let rootPassword = try await BCryptPasswordHasher().hash("root")
        let identityRepository = IdentityDatabaseRepository(context: context)
        let credentialRepository = CredentialDatabaseRepository(
            context: context
        )

        let samples:
            [(
                id: String, email: String, passwordHash: String,
                isPersistent: Bool
            )] = [
                ("root", "mail.tib@gmail.com", rootPassword, true)
            ]

        for sample in samples {
            let identity: Identity
            if let existing = try await identityRepository.findBy(id: sample.id)
            {
                identity = existing
            }
            else {
                identity = try await identityRepository.insert(
                    id: sample.id,
                    model: Identity.create(status: .active)
                )
            }

            guard
                try await credentialRepository.findBy(userId: identity.id)
                    == nil
            else {
                continue
            }

            _ = try await credentialRepository.insert(
                Credential.create(
                    userId: identity.id,
                    email: sample.email,
                    passwordHash: sample.passwordHash,
                    isPersistent: sample.isPersistent
                )
            )
        }
    }
}
