import Domain
import Application
import WebApplication
import BlogDomain

public struct ListPosts: UseCase {
    struct Action: PermissionAction {
        let key = BlogPermissions.Posts.list
    }

    let authorizer: any Authorizer
    let query: any QueryExecutor<ReadPostMetadata>

    public init(
        authorizer: any Authorizer,
        query: any QueryExecutor<ReadPostMetadata>
    ) {
        self.authorizer = authorizer
        self.query = query
    }

    public struct Input: DTO {
        public let query: PostList.Query

        public init(
            query: PostList.Query
        ) {
            self.query = query
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> PostList {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let inputQuery = input.query

        return try await query.run { context in
            let posts = try await context.post.list(query: inputQuery)
            var items: [PostList.Item] = []
            items.reserveCapacity(posts.items.count)
            for item in posts.items {
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
            try await context.post.count(
                query: inputQuery
            )
        }
    }
}
