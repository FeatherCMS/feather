import AuthDomain
public import AuthModule
public import FeatherApplication
public import FeatherModuleKit

extension Email.Remove {
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
            guard try await authorizer.can(subject: subject, perform: Action())
            else {
                throw AuthError(
                    kind: .forbidden,
                    message: Action().key.rawValue
                )
            }
            let ids = try await transaction.run { scope in
                try await scope.authEmail.delete(ids: input.ids)
            }
            return Output(ids: ids)
        }

    }
}
