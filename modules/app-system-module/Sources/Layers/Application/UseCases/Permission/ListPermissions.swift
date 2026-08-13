//
//  ListPermissions.swift
//  app-system-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import FeatherDomain
import SystemDomain

public struct ListPermissions: UseCase {
    struct Action: PermissionAction {
        let key = SystemPermissions.Permissions.list
    }

    let authorizer: any Authorizer
    let query: any QueryExecutor<ReadPermission>

    public init(
        authorizer: any Authorizer,
        query: any QueryExecutor<ReadPermission>
    ) {
        self.authorizer = authorizer
        self.query = query
    }

    public struct Input: DTO {
        public let query: PermissionList.Query

        public init(
            query: PermissionList.Query
        ) {
            self.query = query
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> PermissionList {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let inputQuery = input.query

        return try await query.run { scope in
            try await scope.permission.list(
                query: inputQuery
            )
        }
    }

    public func count(
        subject: Subject,
        input: Input
    ) async throws -> Int {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let inputQuery = input.query

        return try await query.run { scope in
            try await scope.permission.count(
                query: inputQuery
            )
        }
    }
}
