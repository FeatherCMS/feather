public import FeatherApplication
public import FeatherModuleKit
import NewsletterDomain
public import NewsletterModule

extension Campaign.Remove {
    public struct UseCase: FeatherApplication.UseCase {
        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Scope>

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Scope>
        ) {
            self.authorizer = authorizer
            self.transaction = transaction
        }

        public func execute(
            subject: Subject,
            input: Input
        ) async throws -> Output {
            let action = Action()
            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }
            return try await transaction.run { scope in
                var ids: [String] = []
                var keys: [String] = []
                for key in input.keys {
                    guard
                        let campaign = try await scope.campaign.findBy(key: key)
                    else {
                        continue
                    }
                    ids.append(campaign.id)
                    keys.append(key)
                }
                let deletedIDs = try await scope.campaign.delete(ids: ids)
                let deletedIDSet = Set(deletedIDs)
                var deletedKeys: [String] = []
                for index in ids.indices where deletedIDSet.contains(ids[index])
                {
                    deletedKeys.append(keys[index])
                }
                return .init(keys: deletedKeys)
            }
        }
    }
}
