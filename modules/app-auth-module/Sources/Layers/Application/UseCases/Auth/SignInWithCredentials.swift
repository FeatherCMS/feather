//
//  SignInWithCredentials.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

import AuthDomain
import FeatherApplication
import FeatherContracts
import FeatherDomain
import UserDomain

public struct SignInWithCredentials: SignIn {
    let transaction: any TransactionExecutor<WriteAuth>
    let passwordHasher: any PasswordHasher

    public init(
        transaction: any TransactionExecutor<WriteAuth>,
        passwordHasher: any PasswordHasher
    ) {
        self.transaction = transaction
        self.passwordHasher = passwordHasher
    }

    public struct Input: DTO {
        public let object: AuthCredentials

        public init(object: AuthCredentials) {
            self.object = object
        }
    }

    public typealias Output = AuthDetail

    public func execute(
        _ input: Input
    ) async throws -> Output {
        try await transaction.run { scope in
            guard
                let credential = try await scope.credential.findBy(
                    email: input.object.email
                ),
                try await checkPasswordHash(
                    using: passwordHasher,
                    original: input.object.password,
                    hash: credential.passwordHash
                ),
                let user = try await scope.identity.findBy(
                    id: credential.userId
                ),
                user.status == .active
            else {
                throw UseCaseError.authentication()
            }

            return try await makeAuthResponse(
                userIdentityRepository: scope.identity,
                userSessionRepository: scope.session,
                user: user,
                authenticationType: Session.AuthenticationTypes.credential,
                authenticationReference: credential.id,
                isPersistent: input.object.isPersistent
            )
        }
    }
}
