import AccountDomain
public import AccountModule
import AuthDomain
public import FeatherApplication
public import FeatherModuleKit
import UserDomain

//
//  Invitation+Remove+UseCase.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension Invitation.Remove {
    public struct UseCase: FeatherApplication.UseCase {
        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Scope>

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Scope>
        ) {
            self.authorizer = authorizer
            self.transaction = transaction
        }

        public func execute(
            subject: Subject,
            input: Input
        ) async throws -> Output {
            let action = Action()

            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }

            return try await transaction.run { scope in
                var removedIDs: [String] = []
                for id in input.ids {
                    guard
                        let invitation = try await scope.invitation.findBy(
                            id: id
                        )
                    else {
                        continue
                    }
                    if let identity = try await scope.identity.findBy(
                        id: invitation.userId
                    ), identity.status == .invited,
                        let authEmail = try await scope.authEmail.findBy(
                            email: invitation.email
                        ), authEmail.identityId == identity.id
                    {
                        _ = try await scope.authEmail.delete(ids: [authEmail.id]
                        )
                    }
                    removedIDs += try await scope.invitation.delete(ids: [id])
                }
                return Output(ids: removedIDs)
            }
        }
    }
}
