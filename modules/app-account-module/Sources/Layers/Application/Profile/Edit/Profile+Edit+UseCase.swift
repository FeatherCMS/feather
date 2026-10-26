import AccountDomain
public import AccountModule
public import FeatherApplication
public import FeatherModuleKit

extension Profile.Edit {
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
            let userId = input.userId ?? subject.id
            let action = Action(userID: userId)
            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }
            let model = try await transaction.run { scope in
                var model = try await scope.profile.getOrCreate(userId: userId)
                try model.update(
                    firstName: input.firstName,
                    lastName: input.lastName,
                    profileImageAssetId: input.profileImageAssetId
                )
                return try await scope.profile.update(model)
            }
            return .init(
                userId: model.userId,
                firstName: model.firstName,
                lastName: model.lastName,
                profileImageAssetId: model.profileImageAssetId,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt
            )
        }
    }
}
