import AuthDomain
public import AuthModule
public import FeatherApplication
public import FeatherModuleKit

extension MagicLink.Add {
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
        ) async throws -> MagicLink.Detail.Output {
            let action = Action()

            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }

            let model = try await transaction.run { scope in
                try await scope.magicLink.insert(
                    MagicLink.Model.create(
                        authEmailId: input.authEmailId,
                        token: AuthModule.Auth.TokenAuth.generateToken(),
                        isPersistent: input.isPersistent
                    )
                )
            }
            return .init(
                id: model.id,
                authEmailId: model.authEmailId,
                token: model.token,
                expiresAt: model.expiresAt,
                isPersistent: model.isPersistent,
                isUsed: model.isUsed,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt
            )
        }

    }
}
