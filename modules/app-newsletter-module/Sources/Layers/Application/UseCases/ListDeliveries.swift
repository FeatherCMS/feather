import FeatherApplication
import FeatherContracts
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
        public let issueId: String

        public init(issueId: String) {
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
            try await scope.delivery.list(issueId: input.issueId)
                .map(DeliveryDetail.init)
        }
    }
}
