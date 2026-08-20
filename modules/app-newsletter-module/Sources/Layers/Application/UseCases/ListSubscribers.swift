import NewsletterContracts
import FeatherApplication
import FeatherContracts
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
        public let newsletterId: String
        public init(newsletterId: String) { self.newsletterId = newsletterId }
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
            try await scope.subscriber.list(newsletterId: input.newsletterId)
                .map(\.asDetail)
        }
    }
}
