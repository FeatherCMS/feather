import AuthContracts
//
//  ListIdentitySessions.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

import AuthDomain
import FeatherApplication
import FeatherContracts

public struct ListIdentitySessions: UseCase {
    struct Action: PermissionAction {
        let key = AuthPermissions.Sessions.list
    }

    let authorizer: any Authorizer
    let query: any QueryExecutor<ReadSession>

    public init(
        authorizer: any Authorizer,
        query: any QueryExecutor<ReadSession>
    ) {
        self.authorizer = authorizer
        self.query = query
    }

    public struct Input: DTO {
        public let identityId: String

        public init(identityId: String) {
            self.identityId = identityId
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> SessionList {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        return try await query.run { scope in
            try await scope.session.list(
                query: .init(identityId: input.identityId)
            )
        }
    }
}
