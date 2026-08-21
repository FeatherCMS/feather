import AuthContracts
import AuthDomain
import FeatherApplication
import FeatherContracts

//
//  ListCredential.swift
//  app-auth-module
//

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
        public let userId: String?

        public init(
            query: CredentialList.Query,
            userId: String? = nil
        ) {
            self.query = query
            self.userId = userId
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

        return try await query.run { scope in
            if let userId = input.userId {
                return try await scope.credential.list(
                    userId: userId,
                    query: input.query
                )
            }
            return try await scope.credential.list(query: input.query)
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
            if let userId = input.userId {
                return try await scope.credential.count(
                    userId: userId,
                    query: input.query
                )
            }
            return try await scope.credential.count(query: input.query)
        }
    }
}
