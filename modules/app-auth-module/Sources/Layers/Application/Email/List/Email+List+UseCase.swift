import AuthDomain
public import AuthModule
public import FeatherApplication
public import FeatherModuleKit

extension Email.List {
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
        public func execute(subject: Subject) async throws -> Output {
            guard try await authorizer.can(subject: subject, perform: Action())
            else {
                throw AuthError(
                    kind: .forbidden,
                    message: Action().key.rawValue
                )
            }
            return try await transaction.run { scope in
                let models = try await scope.authEmail.list()
                return .init(
                    items: models.map {
                        .init(
                            id: $0.id,
                            identityId: $0.identityId,
                            email: $0.email
                        )
                    }
                )
            }
        }

    }
}
