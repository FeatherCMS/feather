import Application
import BlogDomain
import Domain

public struct EditSettings: UseCase {
    struct Action: PermissionAction {
        let key = BlogPermissions.Settings.update
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteSettings>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteSettings>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let postListPath: String
        public let authorListPath: String
        public let tagListPath: String
        public let postPathPrefix: String
        public let authorPathPrefix: String
        public let tagPathPrefix: String

        public init(
            postListPath: String,
            authorListPath: String,
            tagListPath: String,
            postPathPrefix: String,
            authorPathPrefix: String,
            tagPathPrefix: String
        ) {
            self.postListPath = postListPath
            self.authorListPath = authorListPath
            self.tagListPath = tagListPath
            self.postPathPrefix = postPathPrefix
            self.authorPathPrefix = authorPathPrefix
            self.tagPathPrefix = tagPathPrefix
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> SettingsDetail {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let model = try await transaction.run { context in
            var model = try await context.settings.get()
            try model.update(
                postListPath: input.postListPath,
                authorListPath: input.authorListPath,
                tagListPath: input.tagListPath,
                postPathPrefix: input.postPathPrefix,
                authorPathPrefix: input.authorPathPrefix,
                tagPathPrefix: input.tagPathPrefix
            )
            return try await context.settings.update(model)
        }
        return model.asDetail
    }
}
