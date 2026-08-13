//
//  GetRole.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import UserDomain

public struct GetRole: UseCase {
    struct Action: PermissionAction {
        let key = UserPermissions.Roles.read
    }

    let authorizer: any Authorizer
    let query: any QueryExecutor<ReadRole>

    public init(
        authorizer: any Authorizer,
        query: any QueryExecutor<ReadRole>
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
    ) async throws -> RoleDetail {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        return try await query.run { scope in
            try await scope.role.getBy(id: input.id)
        }
    }
}
