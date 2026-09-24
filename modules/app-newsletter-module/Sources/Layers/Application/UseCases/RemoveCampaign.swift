public import FeatherApplication
public import FeatherContracts
import NewsletterContracts
import NewsletterDomain

public struct RemoveCampaign: UseCase {
    struct Action: PermissionAction { let key = Permissions.Campaigns.delete }
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
        public let keys: [String]
        public init(keys: [String]) { self.keys = keys }
    }
    public func execute(subject: Subject, input: Input) async throws -> [String]
    {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }
        return try await transaction.run { scope in
            var ids: [String] = []
            var keys: [String] = []
            for key in input.keys {
                guard let campaign = try await scope.newsletter.findBy(key: key)
                else { continue }
                ids.append(campaign.id)
                keys.append(key)
            }
            let deletedIDs = try await scope.newsletter.delete(ids: ids)
            return zip(ids, keys).compactMap { id, key in
                deletedIDs.contains(id) ? key : nil
            }
        }
    }
}
