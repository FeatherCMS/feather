public import FeatherApplication
public import FeatherContracts
import NewsletterContracts
import NewsletterDomain

public struct RemoveSubscriber: UseCase {
    struct Action: PermissionAction { let key = Permissions.Subscribers.delete }
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
        public let emails: [String]
        public init(campaignKey: String, emails: [String]) {
            self.campaignKey = campaignKey
            self.emails = emails
        }
    }

    public func execute(subject: Subject, input: Input) async throws -> [String]
    {
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
            return try await scope.subscriber.delete(
                newsletterId: campaign.id,
                emails: input.emails
            )
        }
    }

    public enum Error: UseCaseError { case campaignNotFound }
}
