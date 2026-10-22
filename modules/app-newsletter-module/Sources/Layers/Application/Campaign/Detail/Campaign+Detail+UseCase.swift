public import FeatherApplication
public import FeatherModuleKit
import NewsletterDomain
public import NewsletterModule

extension Campaign.Detail {
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
                let value: Campaign.Model?
                switch input.identifier {
                case .id(let id):
                    value = try await scope.campaign.findBy(id: id)
                case .key(let key):
                    value = try await scope.campaign.findBy(key: key)
                }
                guard let value else { throw Error.notFound }
                return value.asDetail
            }
        }
    }
}
