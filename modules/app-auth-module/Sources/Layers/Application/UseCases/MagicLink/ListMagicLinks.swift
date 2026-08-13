//
//  ListMagicLinks.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

import AuthDomain
import FeatherApplication
import FeatherContracts

public struct ListMagicLinks: UseCase {

    struct Action: PermissionAction {
        let key = AuthPermissions.MagicLinks.list
    }

    let authorizer: any Authorizer
    let query: any QueryExecutor<ReadMagicLink>

    public init(
        authorizer: any Authorizer,
        query: any QueryExecutor<ReadMagicLink>
    ) {
        self.authorizer = authorizer
        self.query = query
    }

    public struct Input: DTO {
        public let query: MagicLinkList.Query

        public init(query: MagicLinkList.Query) {
            self.query = query
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> MagicLinkList {
        guard
            try await authorizer.can(
                subject: subject,
                perform: Action()
            )
        else {
            throw AuthError(
                kind: .forbidden,
                message: Action().key.rawValue
            )
        }

        return try await query.run { scope in
            try await scope.magicLink.list(query: input.query)
        }
    }

    public func count(
        subject: Subject,
        input: Input
    ) async throws -> Int {
        guard
            try await authorizer.can(
                subject: subject,
                perform: Action()
            )
        else {
            throw AuthError(
                kind: .forbidden,
                message: Action().key.rawValue
            )
        }

        return try await query.run { scope in
            try await scope.magicLink.count(query: input.query)
        }
    }
}
