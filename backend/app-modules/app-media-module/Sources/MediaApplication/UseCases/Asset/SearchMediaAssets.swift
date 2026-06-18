import Application

public struct SearchMediaAssets: UseCase {
    struct Action: PermissionAction {
        let key = MediaPermissions.Assets.list
    }

    let authorizer: any Authorizer
    let query: any QueryExecutor<ReadMedia>

    public init(authorizer: any Authorizer, query: any QueryExecutor<ReadMedia>)
    {
        self.authorizer = authorizer
        self.query = query
    }

    public struct Input: DTO {
        public let query: MediaAssetList.Query

        public init(query: MediaAssetList.Query) {
            self.query = query
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> MediaAssetList {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        return try await query.run { context in
            try await context.assets.list(query: input.query)
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
            try await context.assets.count(query: input.query)
        }
    }
}
