public import FeatherApplication
public import FeatherModuleKit
import RedirectDomain
public import RedirectModule

extension Rule.Remove {
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
            let ids = try await transaction.run { scope in
                try await scope.repository.delete(ids: input.ids)
            }
            return .init(ids: ids)
        }
    }
}
