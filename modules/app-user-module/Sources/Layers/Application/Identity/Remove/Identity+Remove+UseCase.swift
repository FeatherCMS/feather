public import FeatherApplication
public import FeatherModuleKit
public import UserDomain
public import UserModule

//
//  Identity.Remove.UseCase.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension Identity.Remove {
    public struct UseCase: FeatherApplication.UseCase {
        struct Action: PermissionAction {
            let key = Identity.Permissions.delete
        }

        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Identity.Repository.Scope>

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Identity.Repository.Scope>
        ) {
            self.authorizer = authorizer
            self.transaction = transaction
        }

        public func execute(
            subject: Subject,
            input: Identity.Remove.Input
        ) async throws -> [String] {
            let action = Action()

            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }

            return try await transaction.run { scope in
                try await scope.identity.delete(ids: input.ids)
            }
        }
    }

}
