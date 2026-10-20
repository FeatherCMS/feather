public import FeatherApplication
public import FeatherModuleKit
public import UserModule

//
//  Role.Detail.UseCase.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension Role.Detail {
    public struct UseCase: FeatherApplication.UseCase {
        struct Action: PermissionAction {
            let key = Role.Permissions.read
        }

        let authorizer: any Authorizer
        let query: any QueryExecutor<Role.Query.Scope>

        public init(
            authorizer: any Authorizer,
            query: any QueryExecutor<Role.Query.Scope>
        ) {
            self.authorizer = authorizer
            self.query = query
        }

        public func execute(
            subject: Subject,
            input: Role.Detail.Input
        ) async throws -> Role.Detail.Output {
            let action = Action()

            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }

            return try await query.run { scope in
                try await scope.role.getBy(id: input.id)
            }
        }
    }

}
