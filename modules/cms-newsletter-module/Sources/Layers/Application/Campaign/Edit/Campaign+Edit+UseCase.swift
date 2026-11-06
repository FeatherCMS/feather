public import FeatherApplication
public import FeatherModuleKit
import NewsletterDomain
public import NewsletterModule

extension Campaign.Edit {
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
                guard
                    var value = try await scope.campaign.findBy(key: input.key)
                else {
                    throw Error.notFound
                }
                try value.update(
                    key: input.newKey,
                    name: input.name,
                    fromEmail: input.fromEmail
                )
                let saved = try await scope.campaign.update(value)
                return .init(
                    id: saved.id,
                    key: saved.key,
                    name: saved.name,
                    fromEmail: saved.fromEmail,
                    createdAt: saved.createdAt,
                    updatedAt: saved.updatedAt
                )
            }
        }
    }
}
