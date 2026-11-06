import AuthDomain
public import AuthModule
public import FeatherApplication
public import FeatherModuleKit

extension Email.Add {
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

        public func execute(subject: Subject, input: Input) async throws
            -> Output
        {
            guard try await authorizer.can(subject: subject, perform: Action())
            else {
                throw AuthError(
                    kind: .forbidden,
                    message: Action().key.rawValue
                )
            }
            let model = try await transaction.run { scope in
                try await scope.authEmail.insert(
                    identityId: input.identityId,
                    email: input.email
                )
            }
            return .init(
                id: model.id,
                identityId: model.identityId,
                email: model.email
            )
        }

    }
}
