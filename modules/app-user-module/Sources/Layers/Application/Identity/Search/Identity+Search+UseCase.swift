public import FeatherApplication
public import FeatherModuleKit
public import UserModule

//
//  Identity.Search.UseCase.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension Identity.Search {
    public struct UseCase: FeatherApplication.UseCase {
        struct Action: PermissionAction {
            let key = Identity.Permissions.list
        }

        let authorizer: any Authorizer
        let query: any QueryExecutor<Identity.Query.Scope>

        public init(
            authorizer: any Authorizer,
            query: any QueryExecutor<Identity.Query.Scope>
        ) {
            self.authorizer = authorizer
            self.query = query
        }

        public func execute(
            subject: Subject,
            input: Identity.Search.Input
        ) async throws -> Identity.Search.Output {
            let action = Action()

            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }

            return try await query.run { scope in
                try await scope.identity.search(query: input.query)
            }
        }
    }

}
