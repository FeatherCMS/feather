//
//  GetCurrentUser.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherApplication
public import FeatherModuleKit
public import UserApplication
public import UserModule

public struct GetCurrentUser: UseCase {
    let detailQuery: any QueryExecutor<Identity.Detail.Scope>
    let authorizationQuery:
        any QueryExecutor<Identity.Authorization.Query.Scope>

    public init(
        detailQuery: any QueryExecutor<Identity.Detail.Scope>,
        authorizationQuery: any QueryExecutor<
            Identity.Authorization.Query.Scope
        >
    ) {
        self.detailQuery = detailQuery
        self.authorizationQuery = authorizationQuery
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
        guard input.id == subject.id else {
            throw AuthError(
                kind: .forbidden,
                message: "Cannot access another identity."
            )
        }

        let identity = try await detailQuery.run { scope in
            try await scope.identity.find(id: input.id)
        }
        async let roles = authorizationQuery.run { scope in
            try await scope.authorization.getRolesBy(identityId: identity.id)
        }
        async let permissions = authorizationQuery.run { scope in
            try await scope.authorization.getPermissionsBy(
                identityId: identity.id
            )
        }
        return try await CurrentUserDetail(
            user: identity,
            roles: roles,
            permissions: permissions
        )
    }
}
