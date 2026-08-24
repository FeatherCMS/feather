import FeatherApplication
import FeatherContracts
import UserContracts
import UserDomain

//
//  GetIdentity.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

public struct GetIdentity: UseCase {
    struct Action: PermissionAction {
        let key = UserPermissions.Identities.read
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
    ) async throws -> IdentityDetail {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        return try await query.run { scope in
            var identity = try await scope.identity.getBy(id: input.id)
            let roleIds = try await scope.identity.getRoleIdsBy(
                identityId: identity.id
            )
            identity = .init(
                id: identity.id,
                roleIds: roleIds,
                status: identity.status,
                createdAt: identity.createdAt,
                updatedAt: identity.updatedAt
            )
            return identity
        }
    }
}
