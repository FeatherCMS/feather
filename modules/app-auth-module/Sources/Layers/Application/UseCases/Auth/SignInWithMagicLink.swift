//
//  SignInWithMagicLink.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

import AuthDomain
import FeatherApplication
import FeatherContracts
import FeatherDomain
import UserDomain

public struct SignInWithMagicLink: SignIn {
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

    public typealias Output = AuthDetail

    public func execute(
        _ input: Input
    ) async throws -> Output {
        try await transaction.run { scope in
            let usedLink: MagicLink
            do {
                usedLink = try await scope.magicLink.consumeByToken(
                    token: input.token
                )
            }
            catch is MagicLink.Error {
                throw UseCaseError.authentication()
            }

            guard
                let authEmail = try await scope.authEmail.findBy(
                    id: usedLink.authEmailId
                ),
                let user = try await scope.identity.findBy(
                    id: authEmail.identityId
                ),
                user.status == .active
            else {
                throw UseCaseError.authentication()
            }

            return try await makeAuthResponse(
                userIdentityRepository: scope.identity,
                userSessionRepository: scope.session,
                user: user,
                authenticationType: Session.AuthenticationTypes.magicLink,
                authenticationReference: usedLink.id,
                isPersistent: usedLink.isPersistent
            )
        }
    }
}
