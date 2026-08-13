//
//  GetCurrentUser.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import UserApplication

public struct GetCurrentUser: UseCase {
    struct Action: PermissionAction {
        let key = PermissionKey("auth:profile:read")
    }

    let authorizer: any Authorizer
    let query: any QueryExecutor<ReadIdentity>

    public init(
        authorizer: any Authorizer,
        query: any QueryExecutor<ReadIdentity>
    ) {
        self.authorizer = authorizer
        self.query = query
    }

    public struct Input: DTO {
        public let id: String

        public init(id: String) {
            self.id = id
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> CurrentUserDetail {
        let action = Action()

        guard input.id == subject.id else {
            throw AuthError(
                kind: .forbidden,
                message: "Cannot access another identity."
            )
        }

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        return try await query.run { scope in
            let identity = try await scope.identity.getBy(id: input.id)

            async let roles = scope.identity.getRolesBy(
                identityId: identity.id
            )

            async let permissions = scope.identity.getPermissionsBy(
                identityId: identity.id
            )

            return try await CurrentUserDetail(
                user: identity,
                roles: roles,
                permissions: permissions
            )
        }
    }
}
