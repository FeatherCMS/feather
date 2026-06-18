import Domain
import Application
import WebApplication
import BlogDomain

public struct ListTags: UseCase {
    struct Action: PermissionAction {
        let key = BlogPermissions.Tags.list
    }

    let authorizer: any Authorizer
    let query: any QueryExecutor<ReadTagMetadata>

    public init(
        authorizer: any Authorizer,
        query: any QueryExecutor<ReadTagMetadata>
    ) {
        self.authorizer = authorizer
        self.query = query
    }

    public struct Input: DTO {
        public let query: TagList.Query

        public init(
            query: TagList.Query
        ) {
            self.query = query
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> TagList {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let inputQuery = input.query

        return try await query.run { context in
            let tags = try await context.tag.list(query: inputQuery)
            var items: [TagList.Item] = []
            items.reserveCapacity(tags.items.count)
            for item in tags.items {
                items.append(
                    .init(
                        id: item.id,
                        title: item.title,
                        excerpt: item.excerpt,
                        imageAssetId: item.imageAssetId,
                        createdAt: item.createdAt,
                        updatedAt: item.updatedAt
                    )
                )
            }
            return .init(items: items)
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
            try await context.tag.count(
                query: inputQuery
            )
        }
    }
}
