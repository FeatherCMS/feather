import NewsletterContracts
import FeatherApplication
import FeatherContracts
import FeatherDomain
import NewsletterDomain

public struct CreateCampaign: UseCase {
    struct Action: PermissionAction { let key = Permissions.Campaigns.create }
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
        public let name: String
        public let fromEmail: String

        public init(
            name: String,
            fromEmail: String = ""
        ) {
            self.name = name
            self.fromEmail = fromEmail
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> CampaignDetail {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }
        return try await transaction.run { scope in
            let model = try Campaign.create(
                name: input.name,
                fromEmail: input.fromEmail
            )
            return try await scope.newsletter.insert(model).asDetail
        }
    }
}
