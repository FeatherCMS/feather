import FeatherApplication
import FeatherContracts
import NewsletterContracts
import NewsletterDomain

public struct GetCampaign: UseCase {
    struct Action: PermissionAction { let key = Permissions.Campaigns.read }
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
        enum Identifier: Sendable {
            case id(String)
            case key(String)
        }

        let identifier: Identifier

        public init(key: String) { self.identifier = .key(key) }
        public init(id: String) { self.identifier = .id(id) }
    }
    public func execute(subject: Subject, input: Input) async throws
        -> CampaignDetail
    {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }
        return try await transaction.run { scope in
            let value: Campaign?
            switch input.identifier {
            case .id(let id):
                value = try await scope.newsletter.findBy(id: id)
            case .key(let key):
                value = try await scope.newsletter.findBy(key: key)
            }
            guard let value
            else { throw Error.notFound }
            return value.asDetail
        }
    }
    public enum Error: UseCaseError { case notFound }
}
