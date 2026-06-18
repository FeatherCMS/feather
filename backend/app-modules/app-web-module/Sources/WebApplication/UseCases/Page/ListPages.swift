import Domain
import Application
import WebApplication
import WebDomain

public struct ListPages: UseCase {
    struct Action: PermissionAction {
        let key = WebPermissions.Pages.list
    }

    let authorizer: any Authorizer
    let query: any QueryExecutor<ReadPageMetadata>

    public init(
        authorizer: any Authorizer,
        query: any QueryExecutor<ReadPageMetadata>
    ) {
        self.authorizer = authorizer
        self.query = query
    }

    public struct Input: DTO {
        public let query: PageList.Query

        public init(
            query: PageList.Query
        ) {
            self.query = query
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> PageList {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let inputQuery = input.query

        return try await query.run { context in
            let pages = try await context.page.list(query: inputQuery)
            var items: [PageList.Item] = []
            items.reserveCapacity(pages.items.count)
            for item in pages.items {
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
            try await context.page.count(
                query: inputQuery
            )
        }
    }
}
