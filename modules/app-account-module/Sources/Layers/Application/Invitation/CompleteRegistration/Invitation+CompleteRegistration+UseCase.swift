import AccountDomain
public import AccountModule
import AuthDomain
public import FeatherApplication
import FeatherDomain
public import FeatherModuleKit
import UserApplication
import UserDomain
import UserModule

//
//  Invitation+CompleteRegistration+UseCase.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 07. 16.

extension Invitation.CompleteRegistration {
    public struct UseCase: FeatherApplication.UseCase {
        let transaction:
            any ContextualTransactionExecutor<
                Invitation.CompleteRegistration.Scope
            >
        public init(
            transaction: any ContextualTransactionExecutor<
                Invitation.CompleteRegistration.Scope
            >
        ) {
            self.transaction = transaction
        }

        public func execute(
            input: Invitation.CompleteRegistration.Input
        ) async throws -> Output {
            try await transaction.run { scope, context in
                guard
                    var invitation = try await scope.invitation.findBy(
                        token: input.token
                    ),
                    var identity = try await scope.identity.findBy(
                        id: invitation.userId
                    ),
                    identity.status == .invited
                else {
                    throw Error(message: "Invitation or identity not found")
                }
                if try await scope.authEmail.findBy(email: invitation.email)
                    == nil
                {
                    _ = try await scope.authEmail.insert(
                        identityId: identity.id,
                        email: invitation.email
                    )
                }
                try await scope.credential.create(
                    userID: identity.id,
                    email: invitation.email,
                    password: input.password,
                    context: context
                )
                try await scope.identity.replaceRoleIds(
                    identityId: identity.id,
                    roleIds: invitation.roleIDs
                )
                try invitation.consume()
                identity.update(status: .set(.active))
                let updated = try await scope.identity.update(identity)
                guard
                    !(try await scope.invitation.delete(ids: [invitation.id]))
                        .isEmpty
                else {
                    throw Error(message: "Invitation already used")
                }
                return .init(
                    id: updated.id,
                    name: updated.name,
                    roleIds: invitation.roleIDs,
                    status: .init(rawValue: updated.status.rawValue)
                        ?? .invited,
                    createdAt: updated.createdAt,
                    updatedAt: updated.updatedAt
                )
            }
        }
    }
}
