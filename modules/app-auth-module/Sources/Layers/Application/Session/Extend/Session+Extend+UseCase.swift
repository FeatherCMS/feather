import AuthDomain
public import AuthModule
public import FeatherApplication
public import FeatherModuleKit

extension Session.Extend {
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
                    let session = try await scope.session.findBy(
                        token: input.token
                    )
                else { return Output(didExtend: false) }

                _ = try await scope.session.update(
                    .init(
                        id: session.id,
                        token: session.token,
                        identityId: session.identityId,
                        authenticationType: session.authenticationType,
                        authenticationReference: session
                            .authenticationReference,
                        expiresAt: input.expiresAt,
                        isPersistent: session.isPersistent,
                        createdAt: session.createdAt,
                        updatedAt: session.updatedAt
                    )
                )
                return Output(didExtend: true)
            }
        }

    }
}
