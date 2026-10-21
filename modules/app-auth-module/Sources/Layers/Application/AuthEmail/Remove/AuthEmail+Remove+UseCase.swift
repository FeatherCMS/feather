import AuthDomain
public import AuthModule
public import FeatherApplication
public import FeatherModuleKit

extension AuthEmail.Remove {
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
        public func execute(subject: Subject, ids: [String]) async throws
            -> [String]
        {
            guard try await authorizer.can(subject: subject, perform: Action())
            else {
                throw AuthError(
                    kind: .forbidden,
                    message: Action().key.rawValue
                )
            }
            return try await transaction.run { scope in
                try await scope.authEmail.delete(ids: ids)
            }
        }

    }
}
