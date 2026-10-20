public import FeatherApplication
public import FeatherModuleKit
public import UserDomain
public import UserModule

//
//  Role.Remove.UseCase.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension Role.Remove {
    public struct UseCase: FeatherApplication.UseCase {
        struct Action: PermissionAction {
            let key = Role.Permissions.delete
        }

        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Role.Repository.Scope>

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Role.Repository.Scope>
        ) {
            self.authorizer = authorizer
            self.transaction = transaction
        }

        public func execute(
            subject: Subject,
            input: Role.Remove.Input
        ) async throws -> [String] {
            let action = Action()

            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }

            return try await transaction.run { scope in
                try await scope.role.delete(ids: input.ids)
            }
        }
    }

}
