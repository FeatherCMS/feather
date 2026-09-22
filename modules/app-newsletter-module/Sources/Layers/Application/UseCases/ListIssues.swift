import FeatherApplication
import FeatherContracts
import NewsletterContracts
import NewsletterDomain

public struct ListIssues: UseCase {
    struct Action: PermissionAction { let key = Permissions.Issues.list }
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

        public init(campaignKey: String) {
            self.campaignKey = campaignKey
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> [IssueDetail] {
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
            return try await scope.issue.list(newsletterId: campaign.id)
                .map(\.asDetail)
        }
    }

    public enum Error: UseCaseError { case campaignNotFound }
}
