//
//  ListCredential.swift
//  app-auth-module
//

import Application
import AuthDomain

public struct ListCredential: UseCase {

    struct Action: PermissionAction {
        let key = AuthPermissions.Credential.list
    }

    let authorizer: any Authorizer
    let query: any QueryExecutor<ReadCredentialLink>

    public init(
        authorizer: any Authorizer,
        query: any QueryExecutor<ReadCredentialLink>
    ) {
        self.authorizer = authorizer
        self.query = query
    }

    public struct Input: DTO {
        public let query: CredentialList.Query
        public let accountID: String?

        public init(
            query: CredentialList.Query,
            accountID: String? = nil
        ) {
            self.query = query
            self.accountID = accountID
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> CredentialList {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        return try await query.run { context in
            if let accountID = input.accountID {
                return try await context.credential.list(
                    accountID: accountID,
                    query: input.query
                )
            }
            return try await context.credential.list(query: input.query)
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

        return try await query.run { context in
            if let accountID = input.accountID {
                return try await context.credential.count(
                    accountID: accountID,
                    query: input.query
                )
            }
            return try await context.credential.count(query: input.query)
        }
    }
}
