public import FeatherApplication
public import FeatherContracts
import NewsletterContracts
import NewsletterDomain

public struct ListSubscribers: UseCase {
    struct Action: PermissionAction { let key = Permissions.Subscribers.list }
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
        enum CampaignIdentifier: Sendable {
            case id(String)
            case key(String)
        }

        let campaignIdentifier: CampaignIdentifier

        public init(campaignKey: String) {
            self.campaignIdentifier = .key(campaignKey)
        }

        public init(newsletterId: String) {
            self.campaignIdentifier = .id(newsletterId)
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> [SubscriberDetail] {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }
        return try await transaction.run { scope in
            let campaignID: String
            switch input.campaignIdentifier {
            case .id(let id):
                campaignID = id
            case .key(let key):
                guard let campaign = try await scope.newsletter.findBy(key: key)
                else { throw Error.campaignNotFound }
                campaignID = campaign.id
            }
            return try await scope.subscriber.list(newsletterId: campaignID)
                .map(\.asDetail)
        }
    }

    public enum Error: UseCaseError { case campaignNotFound }
}
