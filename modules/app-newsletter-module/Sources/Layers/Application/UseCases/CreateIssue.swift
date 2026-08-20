import NewsletterContracts
import FeatherApplication
import FeatherContracts
import FeatherDomain
import NewsletterDomain

public struct CreateIssue: UseCase {
    struct Action: PermissionAction { let key = Permissions.Issues.create }
    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<Write>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<Write>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let newsletterId: String
        public let subject: String
        public let previewText: String
        public let content: String

        public init(
            newsletterId: String,
            subject: String,
            previewText: String = "",
            content: String
        ) {
            self.newsletterId = newsletterId
            self.subject = subject
            self.previewText = previewText
            self.content = content
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> IssueDetail {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }
        return try await transaction.run { scope in
            let model = try Issue.create(
                newsletterId: input.newsletterId,
                subject: input.subject,
                previewText: input.previewText,
                content: input.content
            )
            return (try await scope.issue.insert(model)).asDetail
        }
    }
}
