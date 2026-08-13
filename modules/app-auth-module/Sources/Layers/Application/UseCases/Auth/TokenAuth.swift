//
//  TokenAuth.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

import AuthDomain
import FeatherApplication
import FeatherContracts
import FeatherDomain
import Foundation
import UserDomain

public struct TokenAuth: Sendable {
    let transaction: any TransactionExecutor<WriteAuth>

    public init(
        transaction: any TransactionExecutor<WriteAuth>
    ) {
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let token: String

        public init(token: String) {
            self.token = token
        }
    }

    public typealias Output = AuthResolvedSession?

    public func execute(
        _ input: Input
    ) async throws -> Output {
        let now = Date()

        let resolved: AuthResolvedSession? = try await transaction.run {
            scope in
            guard
                let session = try await scope.session.findBy(
                    token: input.token
                )
            else {
                return nil
            }
            guard session.expiresAt > now.timeIntervalSince1970 else {
                return nil
            }
            guard
                let identity = try await scope.identity
                    .findBy(id: session.identityId)
            else {
                return nil
            }

            let (roles, permissions) = try await (
                scope.identity.findRolesBy(
                    identityId: identity.id
                ),
                scope.identity.findPermissionsBy(
                    identityId: identity.id
                )
            )

            return AuthResolvedSession(
                identityId: identity.id,
                roles: roles,
                permissions: permissions,
                isPersistent: session.isPersistent
            )
        }

        if resolved != nil {
            return resolved
        }

        try await transaction.run { scope in
            if let session = try await scope.session.findBy(
                token: input.token
            ),
                session.expiresAt <= now.timeIntervalSince1970
            {
                _ = try await scope.session.delete(id: session.id)
            }
        }

        return nil
    }
}
