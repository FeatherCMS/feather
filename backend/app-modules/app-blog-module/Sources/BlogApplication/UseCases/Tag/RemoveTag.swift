import Application
import Domain
import WebDomain
import BlogDomain

public struct RemoveTag: UseCase {
    struct Action: PermissionAction {
        let key = BlogPermissions.Tags.delete
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteTagPostsMetadata>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteTagPostsMetadata>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
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
    ) async throws -> Bool {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let id = input.id

        return try await transaction.run { context in
            try await context.post.removeTag(id: id)
            let removedTag = try await context.tag.delete(id: id)
            _ = try await context.metadata.delete(
                reference: .init(type: "blog.tag", id: id)
            )
            return removedTag
        }
    }
}
