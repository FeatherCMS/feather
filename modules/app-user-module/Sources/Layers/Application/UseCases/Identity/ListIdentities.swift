import FeatherApplication
import FeatherContracts
import UserContracts
import UserDomain

//
//  ListIdentities.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

public struct ListIdentities: UseCase {
    struct Action: PermissionAction {
        let key = UserPermissions.Identities.list
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
        public let query: IdentityList.Query

        public init(
            query: IdentityList.Query
        ) {
            self.query = query
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> IdentityList {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        return try await query.run { scope in
            try await scope.identity.list(query: input.query)
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

        return try await query.run { scope in
            try await scope.identity.count(query: input.query)
        }
    }
}
