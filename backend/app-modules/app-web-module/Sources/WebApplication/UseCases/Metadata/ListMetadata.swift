import Domain
import WebDomain
import Application

public struct ListMetadata: UseCase {
    struct Action: PermissionAction {
        let key = WebPermissions.Metadata.list
    }

    let authorizer: any Authorizer
    let query: any QueryExecutor<ReadMetadata>

    public init(
        authorizer: any Authorizer,
        query: any QueryExecutor<ReadMetadata>
    ) {
        self.authorizer = authorizer
        self.query = query
    }

    public struct Input: DTO {
        public let query: MetadataList.Query

        public init(
            query: MetadataList.Query
        ) {
            self.query = query
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> MetadataList {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let inputQuery = input.query

        return try await query.run { context in
            try await context.metadata.list(
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

        return try await query.run { context in
            try await context.metadata.count(
                query: inputQuery
            )
        }
    }
}
