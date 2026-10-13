//
//  GetCurrentUser.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherApplication
public import FeatherContracts
public import UserApplication

public struct GetCurrentUser: UseCase {
    let query: any QueryExecutor<ReadIdentity>

    public init(
        query: any QueryExecutor<ReadIdentity>
    ) {
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
        guard input.id == subject.id else {
            throw AuthError(
                kind: .forbidden,
                message: "Cannot access another identity."
            )
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
