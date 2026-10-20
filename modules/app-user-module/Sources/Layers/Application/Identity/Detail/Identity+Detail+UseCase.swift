public import FeatherApplication
public import FeatherModuleKit
public import UserModule

//
//  Identity.Detail.UseCase.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension Identity.Detail {
    public struct UseCase: FeatherApplication.UseCase {
        struct Action: PermissionAction {
            let key = Identity.Permissions.read
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
            input: Identity.Detail.Input
        ) async throws -> Identity.Detail.Output {
            let action = Action()

            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }

            return try await query.run { scope in
                var identity = try await scope.identity.getBy(id: input.id)
                let roleIds = try await scope.identity.getRoleIdsBy(
                    identityId: identity.id
                )
                identity = .init(
                    id: identity.id,
                    name: identity.name,
                    roleIds: roleIds,
                    status: identity.status,
                    createdAt: identity.createdAt,
                    updatedAt: identity.updatedAt
                )
                return identity
            }
        }
    }

}
