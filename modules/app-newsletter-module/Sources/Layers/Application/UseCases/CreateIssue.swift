public import FeatherApplication
public import FeatherContracts
import NewsletterContracts
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
        public let campaignKey: String
        public let subject: String
        public let previewText: String
        public let content: String

        public init(
            campaignKey: String,
            subject: String,
            previewText: String = "",
            content: String
        ) {
            self.campaignKey = campaignKey
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
            guard
                let campaign = try await scope.newsletter.findBy(
                    key: input.campaignKey
                )
            else { throw Error.campaignNotFound }
            let model = try Issue.create(
                newsletterId: campaign.id,
                subject: input.subject,
                previewText: input.previewText,
                content: input.content
            )
            return (try await scope.issue.insert(model)).asDetail
        }
    }

    public enum Error: UseCaseError { case campaignNotFound }
}
