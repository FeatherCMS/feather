import FeatherApplication
import FeatherContracts
import NewsletterContracts
import NewsletterDomain

public struct GetSubscriber: UseCase {
    struct Error: UseCaseError { let message: String }
    struct Action: PermissionAction { let key = Permissions.Subscribers.read }
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
        public let email: String
        public init(campaignKey: String, email: String) {
            self.campaignKey = campaignKey
            self.email = email
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> SubscriberDetail {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }
        return try await transaction.run { scope in
            guard
                let campaign = try await scope.newsletter.findBy(
                    key: input.campaignKey
                )
            else { throw Error(message: "Newsletter campaign not found") }
            guard
                let value = try await scope.subscriber.findBy(
                    newsletterId: campaign.id,
                    email: input.email
                )
            else { throw Error(message: "Newsletter subscriber not found") }
            return value.asDetail
        }
    }
}
