import FeatherApplication
import FeatherContracts
import NewsletterContracts
import NewsletterDomain

public struct DeleteSubscriber: UseCase {
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
        public let newsletterId: String
        public let emails: [String]
        public init(newsletterId: String, emails: [String]) {
            self.newsletterId = newsletterId
            self.emails = emails
        }
    }

    public func execute(subject: Subject, input: Input) async throws -> [String] {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }
        return try await transaction.run { scope in
            try await scope.subscriber.delete(
                newsletterId: input.newsletterId,
                emails: input.emails
            )
        }
    }
}
