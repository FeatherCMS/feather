import AuthDomain
public import AuthModule
public import FeatherApplication
public import FeatherModuleKit

extension MagicLink.Edit {
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
                guard
                    let existing = try await scope.magicLink.findById(
                        id: input.id
                    )
                else {
                    throw UseCaseError(
                        reason: .validation,
                        logMessage: "Magic link not found: \(input.id)",
                        userFriendlyMessage: "Magic link not found"
                    )
                }

                let updated = MagicLink.Model(
                    id: existing.id,
                    authEmailId: input.authEmailId
                        ?? existing.authEmailId,
                    token: existing.token,
                    expiresAt: existing.expiresAt,
                    isPersistent: input.isPersistent ?? existing.isPersistent,
                    isUsed: existing.isUsed,
                    createdAt: existing.createdAt,
                    updatedAt: existing.updatedAt
                )

                return try await scope.magicLink.update(updated)
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
