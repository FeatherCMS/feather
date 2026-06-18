import Application
import Domain
import WebApplication
import WebDomain

public struct GetPage: UseCase {
    struct Action: PermissionAction {
        let key = WebPermissions.Pages.read
    }

    struct Error: UseCaseError {
        let message: String
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
        public let id: String

        public init(
            id: String
        ) {
            self.id = id
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> PageDetail {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let id = input.id

        return try await query.run { context in
            let page = try await context.page.find(id: id)
            guard
                let metadata = try await context.metadata.find(
                    referenceType: "web.page",
                    referenceID: id
                )
            else {
                throw Error(message: "Page metadata not found")
            }
            return .init(
                id: page.id,
                title: page.title,
                excerpt: page.excerpt,
                content: page.content,
                imageAssetId: page.imageAssetId,
                metadata: metadata,
                createdAt: page.createdAt,
                updatedAt: page.updatedAt
            )
        }
    }
}
