import FeatherApplication
import FeatherContracts
import NewsletterContracts
import NewsletterDomain

public struct ListDeliveries: UseCase {
    struct Action: PermissionAction { let key = Permissions.Issues.read }
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
        public let issueId: String

        public init(
            campaignKey: String,
            issueId: String
        ) {
            self.campaignKey = campaignKey
            self.issueId = issueId
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> [DeliveryDetail] {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }
        return try await transaction.run { scope in
            guard
                let campaign = try await scope.newsletter.findBy(
                    key: input.campaignKey
                ),
                let issue = try await scope.issue.findBy(id: input.issueId),
                issue.newsletterId == campaign.id
            else { throw Error.notFound }
            return try await scope.delivery.list(issueId: input.issueId)
                .map(DeliveryDetail.init)
        }
    }

    public enum Error: UseCaseError { case notFound }
}
