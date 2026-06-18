import Application
import Domain
import BlogDomain

public struct EditAuthorLink: UseCase {

    struct Action: PermissionAction {
        let key = BlogPermissions.AuthorLinks.update
    }

    struct Error: UseCaseError {
        let message: String
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
        public let label: String?
        public let url: String?
        public let priority: Int?
        public let isBlank: Bool?
        public let permission: String?
        public let notes: String?

        public init(
            id: String,
            authorId: String,
            label: String?,
            url: String?,
            priority: Int?,
            isBlank: Bool?,
            permission: String?,
            notes: String?
        ) {
            self.id = id
            self.authorId = authorId
            self.label = label
            self.url = url
            self.priority = priority
            self.isBlank = isBlank
            self.permission = permission
            self.notes = notes
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> AuthorLinkDetail {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let model = try await transaction.run { context in
            guard var model = try await context.authorLink.find(id: input.id)
            else {
                throw Error(message: "Menu item not found")
            }
            guard model.authorId == input.authorId else {
                throw Error(message: "Menu item not found")
            }

            try model.update(
                label: input.label,
                url: input.url,
                priority: input.priority,
                isBlank: input.isBlank,
                permission: input.permission,
                notes: input.notes
            )

            return try await context.authorLink.update(model)
        }
        return model.asDetail
    }
}
