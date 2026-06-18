import Application
import Domain
import BlogDomain

public struct RemoveAuthorLink: UseCase {
    struct Action: PermissionAction {
        let key = BlogPermissions.AuthorLinks.delete
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteAuthorLink>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteAuthorLink>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let id: String
        public let authorId: String

        public init(
            id: String,
            authorId: String
        ) {
            self.id = id
            self.authorId = authorId
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

        return try await transaction.run { context in
            guard let model = try await context.authorLink.find(id: input.id),
                model.authorId == input.authorId
            else {
                return false
            }
            return try await context.authorLink.delete(id: model.id)
        }
    }
}
