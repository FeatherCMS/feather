import FeatherApplication
import FeatherContracts
import NewsletterContracts
import NewsletterDomain

public struct UpdateCampaign: UseCase {
    struct Action: PermissionAction { let key = Permissions.Campaigns.update }
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
        public let id: String
        public let name: String
        public let fromEmail: String

        public init(
            id: String,
            name: String,
            fromEmail: String
        ) {
            self.id = id
            self.name = name
            self.fromEmail = fromEmail
        }
    }
    public func execute(subject: Subject, input: Input) async throws
        -> CampaignDetail
    {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }
        return try await transaction.run { scope in
            guard var value = try await scope.newsletter.findBy(id: input.id)
            else { throw Error.notFound }
            try value.update(name: input.name, fromEmail: input.fromEmail)
            return (try await scope.newsletter.update(value)).asDetail
        }
    }
    public enum Error: UseCaseError { case notFound }
}
