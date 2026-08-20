import NewsletterContracts
import FeatherApplication
import FeatherContracts
import NewsletterDomain

public struct ListCampaigns: UseCase {
    struct Action: PermissionAction { let key = Permissions.Campaigns.list }
    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<Write>
    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<Write>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }
    public struct Input: DTO { public init() {} }
    public func execute(subject: Subject, input: Input) async throws
        -> [CampaignDetail]
    {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }
        return try await transaction.run { scope in
            try await scope.newsletter.list().map(\.asDetail)
        }
    }
}
