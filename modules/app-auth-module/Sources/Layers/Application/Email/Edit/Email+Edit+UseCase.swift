import AuthDomain
public import AuthModule
public import FeatherApplication
import FeatherDomain
public import FeatherModuleKit

extension Email.Edit {
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
                guard var model = try await scope.authEmail.findBy(id: input.id)
                else {
                    throw Error.authEmailNotFound
                }
                model.update(
                    identityId: input.identityId,
                    email: input.email
                )
                return try await scope.authEmail.update(model)
            }
            return .init(
                id: model.id,
                identityId: model.identityId,
                email: model.email
            )
        }

    }
}
