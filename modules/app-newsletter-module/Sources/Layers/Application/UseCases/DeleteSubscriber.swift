import FeatherApplication
import FeatherContracts
import NewsletterContracts
import NewsletterDomain

public struct DeleteSubscriber: UseCase {
    struct Error: UseCaseError { let message: String }
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
        public let email: String
        public init(newsletterId: String, email: String) {
            self.newsletterId = newsletterId
            self.email = email
        }
    }

    public func execute(subject: Subject, input: Input) async throws {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }
        try await transaction.run { scope in
            guard
                try await scope.subscriber.delete(
                    newsletterId: input.newsletterId,
                    email: input.email
                )
            else { throw Error(message: "Newsletter subscriber not found") }
        }
    }
}
