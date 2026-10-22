import AccountDomain
public import AccountModule
import AuthDomain
public import FeatherApplication
public import FeatherModuleKit
import UserDomain

//
//  Invitation+Edit+UseCase.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension Invitation.Edit {
    public struct UseCase: FeatherApplication.UseCase {
        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Invitation.Edit.Scope>

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Invitation.Edit.Scope>
        ) {
            self.authorizer = authorizer
            self.transaction = transaction
        }

        public func execute(
            subject: Subject,
            input: Invitation.Edit.Input
        ) async throws -> Invitation.Detail.Output {
            let action = Action()

            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }

            let model = try await transaction.run { scope in
                guard
                    var model = try await scope.invitation.findBy(id: input.id)
                else {
                    throw Error(message: "Invitation not found")
                }

                for roleID in input.roleIDs ?? [] {
                    guard try await scope.role.findBy(id: roleID) != nil else {
                        throw Error(message: "Role not found: \(roleID)")
                    }
                }

                let previousEmail = model.email
                try model.update(email: input.email, roleIDs: input.roleIDs)
                if previousEmail != model.email,
                    let identity = try await scope.identity.findBy(
                        id: model.userId
                    ),
                    identity.status == .invited
                {
                    if var authEmail = try await scope.authEmail.findBy(
                        email: previousEmail
                    ), authEmail.identityId == identity.id {
                        authEmail.email = model.email
                        _ = try await scope.authEmail.update(authEmail)
                    }
                    else {
                        _ = try await scope.authEmail.insert(
                            identityId: identity.id,
                            email: model.email
                        )
                    }
                }
                return try await scope.invitation.update(model)
            }

            return .init(
                id: model.id,
                userId: model.userId,
                email: model.email,
                token: model.token,
                roleIDs: model.roleIDs,
                expiresAt: model.expiresAt,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt
            )
        }
    }
}
